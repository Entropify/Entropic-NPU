# Entropic-NPU — Architecture Decision Log

Two-person project: **Person A (hardware/RTL)** and **Person B (software/training)**.
Every decision here is binding on **both** halves. If you change one, change this file in
the same commit and say why.

Format: context → decision → consequences → what it obliges the other side to do.

---

## ADR-001 — Weights are loaded at runtime, never baked in

**Context.** `$readmemh` and `localparam` tables freeze weights into the bitstream: every
retrain costs a Vivado rebuild, and one bitstream serves one model.

**Decision.** All weights, biases and per-layer scales arrive over UART at boot and live in
BRAM. No `$readmemh` in synthesised hardware (simulation only). Every weight address, bias
value and shift sits behind a register the loader writes.

**Consequences.**
- One bitstream runs any trained model in the hardware's instruction set.
- Load time ~250 ms for a 24 KiB payload at 1 Mbaud; ~22 ms once the payload shrinks (§ADR-004).
- The loader must validate: magic, version, length, **CRC-32**, and a frame timeout. A
  half-loaded model produces plausible logits and no error message.

**Obliges Person B:** implement the exporter that emits this payload (format in ADR-002/003).

---

## ADR-002 — The weight stream is laid out in 36-byte beats

**Context.** `pe_array` consumes 9 taps × 4 lanes = **36 weight bytes per clock**. Any other
layout forces the hardware to generate addresses, multiply strides and swizzle bytes.

**Decision.** The exporter emits weights as consecutive 36-byte "beats", in exactly the
order the FSM consumes them. The hardware reader is then a **counter**, not an address
generator.

Per model: conv1 2 beats (72 B), conv2 32 beats (1,152 B), FC 3 groups × 216 beats
(23,328 B with padding) — 682 beats, 24,552 B for the current dense-FC shape.

**Consequences.** A transposed layout attaches every weight to the wrong MAC: the network
runs, produces logits, and is simply wrong. This is the same failure class as the flatten
order, and it needs the same defence — a written contract plus a bit-exact diff.

**Obliges Person B:** emit beats in FSM order, and publish a per-layer checksum.

---

## ADR-003 — `npu_top` is a sequencer over a descriptor table

**Context.** A fixed `S_CONV1 / S_POOL1 / S_CONV2 …` state machine makes every new model a
new synthesis, which defeats ADR-001.

**Decision.** The payload carries a header and per-layer descriptors; `npu_top` walks the
list. Reserved kinds: **0 = conv3×3, 1 = pool2×2, 2 = fc, 3 = gap**.

Per layer (6 bytes): `kind, in_ch, out_ch, W, H, shift`. Weight and bias base addresses are
derived by the loader with running counters, so a malformed base cannot exist.

**What may vary per model:** layer count and order, channel counts ≤ 16, map sizes,
class count, all weights/biases/shifts.
**Fixed in silicon:** kernel 3×3, stride 1, valid padding, pool 2×2, ReLU (the clamp inside
`requant`), 4 channels per beat.

**Consequences.** A new model is data. A new *primitive* is one new `case` in the sequencer
plus one module — additive, no rewiring.

---

## ADR-004 — Global average pooling after pool2  ⚠️ changes the network

**Context.** The dense FC sees 11×11×16 = **1,936** features.

```
10 classes -> 19,360 weights -> ~24 KiB payload   fits a 36 KiB bank   ✅
26 classes -> 50,336 weights -> ~49 KiB payload   overflows the bank    ❌
```

So the dense-FC shape caps the class count at ~16 and the letters/multi-class models cannot
fit. Needing more classes therefore forces a smaller FC.

**Decision.** Run **global average pooling** after pool2: each of the 16 channel maps
collapses from 121 values to one, so the FC sees **16 features**.

```
26 classes -> 16 x 26 = 416 weights -> ~0.5 KiB of beats   ✅
```

**Hardware.** 16 × 16-bit accumulators (one per channel), sum the map, then `>> 7`
(divide by **128**), saturate to a byte. 256 FF, 0 DSP, 0 BRAM, ~120 lines, descriptor
`kind = 3`. Latency: 1 clock after the map ends, then 4 output beats.

**Why ÷128 and not ÷121.** 128 is free wiring; the 5.8% scale difference is a *scale*, not
an error — provided both sides use the same divisor.

**Consequences.**
- Class count stops being the memory driver: 26 or 32 classes are now cheap.
- GAP discards spatial position. Validate accuracy against the dense-FC model before
  committing; for centred handwriting it is normally within noise.
- Build it **after first light**, as the first demonstration of extensibility (ADR-003 makes
  it additive).

**Obliges Person B:** train the network with a GAP layer after pool2 and **normalise the
GAP output by 128, not 121**. Confirm the accuracy delta against the dense model and record
it here.

---

## ADR-005 — `argmax` sizing: capacity vs in-use

**Context.** Class count is now data (ADR-004), but the register file that holds the logits
needs a compile-time depth.

**Decision.** Two separate knobs:
- `max_classes = 32` — capacity, fixed at build (1,024 FF, 2.5% of budget).
- `n_classes` — in use this inference, from the descriptor (10 digits, 26 letters).

`argmax` walks `0 … n_classes-1` and ignores the rest. Ties: **first index wins**. The guard
flags `n_classes > max_classes` instead of emitting a wrong index.

---

## ADR-006 — `pool` stays max, one instance, immutable weights

2×2 max, stride 2, output rate ¼ of input. 2,304 pixels → exactly **576** outputs for a
48×48 map. `rowbuf` holds half a row (`W/2`), not a whole row, because each horizontal pair
is collapsed before it is stored. One instance sized `W = 48` serves both layers (the 22-wide
map uses 11 of the 24 columns, and groups 2-3 idle during conv1) — the ~200 idle bytes buy
one block and one output bus instead of two.

---

## Open questions

| # | Question | Who |
|---|---|---|
| 1 | Second model: how many classes, and does it share the 50×50 grayscale input? | both |
| 2 | GAP accuracy delta vs dense FC — measured, not assumed | Person B |
| 3 | UART baud: 1 Mbaud baseline, or push for 2? | A |
| 4 | Does the FSM ever assert reset mid-map? (would need a buffer flush) | A |
| 5 | `requant` shift values per layer, from the trained model | Person B |
