# PERSON A — Hardware / Chip Design / FPGA

**Role:** own everything between "a hex file exists" and "the FPGA produces the right number".
RTL, memory architecture, clocking, constraints, timing closure, bitstream, on-board debug.

**Mission:** an NPU in Verilog on the Basys3 (XC7A35T) that takes a 50×50 grayscale image over UART and
returns a digit class, with every intermediate number byte-identical to Person B's integer model.

**"Done" for this role** = a bitstream that (a) passes 100% of the frozen test-vector regression in
simulation, (b) closes timing with positive WNS at the design clock, (c) classifies 20/20 of Person B's
hand-drawn digits on real hardware with the same result as the golden model, (d) reports its own
utilisation / latency / baud numbers into `docs/` that Person B can cite.

**Companion document:** `TEAM-B-software-ai.md`. §0 (the contract) is identical in both files.

---

## §0 SHARED CONTRACT v1.0 — FROZEN. Do not change unilaterally.

This is the interface between the two halves of the project. It is the *only* thing that keeps two people
working independently from producing two incompatible halves. Any change requires both people to agree,
bumps the version, and means Person B re-exports vectors and Person A re-runs the full regression.

### 0.1 Numeric spec

| Item | v1 (MLP, first light) | v2 (CNN, the real NPU) |
|---|---|---|
| Input image | uint8, 28×28, row-major, **255 = ink, 0 = background** | uint8, 50×50, same convention |
| Activations | uint8, zero-point 0, per-tensor power-of-two scale `2^-n` | same |
| Weights | int8, per-tensor scale `2^-m` | int8, per-tensor (per-channel from v2.1) |
| Bias | int32, pre-scaled by the exporter into accumulator units | same |
| Accumulator | int32 | int32 (≥24 bits guaranteed used) |
| Requantisation | `sat_u8(round_half_away_from_zero(acc >> s))`, `s` integer ≥ 0 | same |
| Multiplier `M` | **always 1** (power-of-two scales only — requant is a shift) | same |
| Activation fn | ReLU (negative → 0) then saturate to uint8 | same |
| Pooling | n/a | max, 2×2 stride 2, valid (no padding) |
| Padding | none (valid) | none (valid) |
| Argmax | **lowest index wins** on tie | same |
| Convolution order | n/a | `[Cout][Cin][KH][KW]` row-major |

Rule that matters most: **rounding is round-half-away-from-zero, not floor, not banker's.** Both sides
implement the same three lines and both have a unit test with negative and tie values.

### 0.2 Model v1 (first light) and v2 (target)

```
v1: 784 -> FC 64 -> ReLU -> FC 32 -> ReLU -> FC 10 -> argmax        (28x28 input)
v2: conv 3x3 (1->8) -> ReLU -> maxpool 2x2
    -> conv 3x3 (8->16) -> ReLU -> maxpool 2x2
    -> FC (1936->10) -> argmax                                      (50x50 input)
```

### 0.3 File formats

- `rtl/hex/w<N>.hex` — one byte per line, lowercase two hex digits, `$readmemh`-compatible.
  FC: `[out][in]` row-major. Conv: `[Cout][Cin][KH][KW]`.
- `rtl/hex/b<N>.hex` — int32 biases, one 8-digit hex word per line.
- `model.json` — contract version, model name/id, layer list with dimensions, bit widths, scales as
  exponents, and the SHA-256 of every `.hex` file. **Person A's RTL and Person B's exporter both read it.**
  If the SHA doesn't match what's in BRAM, the run is invalid.

### 0.4 Test vectors (the artifact that lets Person A work without Person B)

```
vectors/
  manifest.json        {"contract":"1.0","model":"mlp_v1","cases":[
                          {"id":0,"in":"case_0000.in.bin","dumps":["case_0000.l0.bin",...],
                           "logits":"case_0000.logits.txt","argmax":7}, ...]}
  case_0000.in.bin     uint8 input, row-major, 784 (v1) or 2500 (v2) bytes
  case_0000.l0.bin     activation dump after layer 0, uint8 row-major
  case_0000.logits.txt one int32 per line (10 lines) + final line "argmax <d>"
```

### 0.5 Host ↔ device interface (UART)

- Baud: **1,000,000** target (`115200` for bring-up). 8N1. Byte-level, no flow control.
- Frame: `0xA5 | OP | LEN_LO | LEN_HI | PAYLOAD[LEN] | CRC8 | 0x5A` (LEN little-endian, 16-bit).
- CRC8: poly `0x07`, init `0x00`, no reflection, no final XOR — over `OP..PAYLOAD` only.
- Response: `0x5A | (OP|0x80) | LEN_LO | LEN_HI | PAYLOAD | CRC8 | 0xA5`, same CRC definition.

| OP | Name | Payload |
|---|---|---|
| `0x01` | LOAD_IMG | raw uint8 image, row-major |
| `0x02` | LOAD_WEIGHTS | `layer_id(1) | len(4, LE) | bytes` |
| `0x03` | START | empty |
| `0x04` | GET_RESULT | empty → returns `digit(1) | status(3)` |
| `0x05` | LOOPBACK | echoes payload (bring-up / baud validation) |
| `0x06` | READ_LOGITS | empty → 10 × int32 LE |
| `0x07` | DUMP_ACT | `layer_id(1)` → uint8 activation dump (**debug builds only**) |
| `0x08` | GET_INFO | empty → contract major/minor, model id, P (parallelism), clock Hz |

### 0.6 Register map (MMIO, for the soft-core path or an equivalent FSM register file)

| Offset | Name | Dir | Meaning |
|---|---|---|---|
| `0x000` | CTRL | W | bit0 start, bit1 soft reset, bit2 abort |
| `0x004` | STATUS | R | bit0 busy, bit1 done, bit2 error (crc/protocol), bit3 weights loaded |
| `0x008` | RESULT | R | `[3:0]` argmax digit |
| `0x00C` | VERSION | R | `0x0001_0000` = contract 1.0 |
| `0x010` | IMG_WADDR | W | image byte address |
| `0x014` | IMG_WDATA | W | image byte |
| `0x018` | W_WADDR | W | weight byte address (within the layer selected by `W_LAYER`) |
| `0x01C` | W_DATA | W | weight byte |
| `0x020` | W_LAYER | W | layer id for weight writes |
| `0x030` | LOUT_ADDR | W | logit index 0..9 |
| `0x034` | LOUT_DATA | R | int32 logit |

All multi-byte registers are little-endian; `IMG_WADDR`/`W_WADDR` auto-increment on write if bit31 is set.

### 0.7 Budgets (both people design to these)

| Quantity | Value | Consequence |
|---|---|---|
| Design clock | 100 MHz (Basys3 W5), 200 MHz only if it closes | timing closure target |
| Parallel MACs `P` | 16 (v1) → 32 (v2) of 90 DSPs | latency and adder-tree sizing |
| Inference latency | ≤ 1 ms (v1), ≤ 500 µs (v2) | Person B's benchmark target |
| Link throughput | ≥ 1 Mbaud = 2500 B in 25 ms | the system is **link-bound**, not compute-bound |
| Accuracy | ≥ 98.5% MNIST test (v1), ≥ 98.5% own-drawings (v2) | gates on Person B |
| BRAM | ≤ 40 of 50 blocks total | leaves room for line buffers |

---

## §1 Artifacts Person A owns

```
rtl/
  compute/   mac.v, mac_array.v, requant.v, relu.v, pool.v, argmax.v, conv_engine.v, fc_engine.v
  memory/    weight_bram.v, img_buffer.v, line_buffer.v
  io/        uart_rx.v, uart_tx.v, crc8.v, host_if.v
  npu_top.v, top_basys3.v        (+ soc_wrapper.v if you use the R32 soft core)
  hex/       (generated by Person B — read-only for you)
sim/         tb_*.v (structural, by you) ; cocotb tests are Person B's (see §5)
syn/         basys3.xdc, build_basys3.tcl
docs/        utilisation.md, timing.md, latency.md
```

**Never hand-edit anything in `hex/`.** If a weight is wrong, Person B re-exports.

---

## §2 What Person A must learn

### Tier A1 — Datapath design, not just logic (weeks 1–4)

You already write synthesizable Verilog and have shipped a soft core. What's missing is *arithmetic
architecture*: pipelining a multiply-accumulate, resource sharing, adder trees, and the latency/area
tradeoff underneath every choice.

- **Steve Kilts, *Advanced FPGA Design: Architecture, Implementation, and Optimization*** — the single
  most relevant book. Read: pipelining, resource sharing, area/speed tradeoffs, clock domain crossing,
  coding for synthesis. *Why:* it is the book about building datapaths; almost every phase H1–H5 decision
  is in here.
  <https://www.fpgarelated.com/books/27.php>
- **Uwe Meyer-Baese, *Digital Signal Processing with Field Programmable Gate Arrays*** — chapters on MAC
  design, pipelining, systolic FIR filters, distributed arithmetic. *Why:* a 2-D convolution engine is a
  systolic FIR filter with a different address generator; the accumulator-width and pipeline-stage
  reasoning transfers directly.
- **Pong P. Chu, *FPGA Prototyping by Verilog Examples*** — reference patterns for BRAM, FSM+datapath
  splitting, and testbench structure. *Why:* fast, concrete templates rather than theory.
- **Clifford Cummings' papers** (nonblocking assignments, coding guidelines) — Sunset/Sunburst,
  <http://www.sunburst-design.com/papers/>. *Why:* the cheap way to never debug a sim/synth mismatch again.
  Your own history proves this matters: a wrong `$readmemh` path is silent and yields an all-zero ROM.

**Exit test:** you have a parameterized, pipelined `mac.v` (3 stages, signed int8 × int8 → int32) with a
cocotb testbench, a positive-WNS timing report, and `report_utilization` showing DSP48E1 inference. You can
explain to Person B where every bit of the accumulator width goes.

### Tier A2 — The DSP48E1 and 7-series memory, in detail (weeks 3–4)

Your gains come from using the hardened silicon instead of LUTs, and from knowing exactly what a BRAM
block can and cannot be configured as.

- **UG479, *7 Series DSP48E1 Slice User Guide*** — the 25×18 multiplier, the 48-bit accumulator, the
  pre-adder, pipeline registers, MACC, SIMD modes. *Why:* the pre-adder and internal accumulator are how
  you cut LUT pressure on a 35T; also the source of truth for what infers and what doesn't.
  <https://docs.amd.com/r/en-US/ug479-7series-dsp48e1>
- **UG473, *7 Series FPGAs Memory Resources*** — RAMB36E1/RAMB18E1, width configurations (1/2/4/9/18/36),
  simple vs true dual port, cascade, and what "byte-wide" really gives you (4 KiB per block).
  <https://docs.amd.com/r/en-US/ug473-7series-memory-resources>
- **UG901 *Synthesis*, UG903 *Constraints*, UG949 *Methodology*, UG906 *Timing Analysis*** — read UG901's
  RAM/ROM inference coding patterns and UG906's timing-report sections. *Why:* you will read a routed
  timing report a hundred times; learn to find the critical path from the report instead of guessing.
- **Xilinx WP486, *Deep Learning with INT8 Optimization on Xilinx Devices*** — the vendor's account of int8
  on DSP48. Short, and it frames why int8 is the natural precision on this silicon.
  <https://docs.amd.com/v/u/en-US/wp486-deep-learning-int8>

**Exit test:** you can state, without the tool, how many DSP48E1 slices a P-wide int8 MAC array uses, what
the accumulator width must be for a 3×3×16-tap dot product, and how many 36 Kb blocks a 20 KiB weight set
consumes (answer: 5).

### Tier A3 — Accelerator architecture vocabulary (weeks 4–7)

You can build any of these in RTL; the point is choosing the one that fits 90 DSPs and 225 KiB.

- **Sze, Chen, Yang, Emer — *Efficient Processing of Deep Neural Networks*** (Synthesis Lectures). Free
  precursor paper: *Efficient Processing of Deep Neural Networks: A Tutorial and Survey*, arXiv:1703.09039.
  *Why:* dataflows (weight-stationary / output-stationary / row-stationary), loop tiling and unrolling,
  the memory hierarchy, and the arithmetic-intensity reasoning that decides your architecture.
- **Chen et al., Eyeriss (ISCA 2016)** and **Jouppi et al., TPU (ISCA 2017)** — read for the architecture,
  skim the numbers. *Why:* the two canonical array designs your Phase H5 sits between.
- **Umuroglu et al., FINN (FPGA 2017)** + `Xilinx/finn` docs — *Why:* how a dataflow accelerator's
  control and parallelism are structured; also tells you what you're deliberately NOT adopting.
- **MIT 6.5940 "TinyML and Efficient Deep Learning Computing"**, the "Hardware Acceleration" and
  "Quantization" lectures — <https://hanlab.mit.edu/courses>. *Why:* shared vocabulary with Person B;
  watch these two lectures together so you both use the same words for the same things.

**Exit test:** for the v2 CNN you can name, with numbers, the dataflow you chose, the tile sizes, how many
cycles each layer takes at P=32, and where every byte of weight and activation storage lives.

### Tier A4 — Verification and bring-up discipline (continuous)

- **cocotb docs** — <https://docs.cocotb.org/>. You'll review Person B's tests even though they write them.
- **Verilator / Icarus** — your simulation of record (your own experience: xsim rejects forward-declared
  identifiers that synthesis and Icarus accept — simulate with Icarus).
- **ZipCPU tutorial + blog** — <https://zipcpu.com/tutorial>, and *Learning AXI: where to start?*
  <https://zipcpu.com/blog/2022/05/07/learning-axi.html>. *Why:* FSM/datapath style, handshake discipline,
  and the "assertions before waveforms" mindset. Read the AXI piece before you design `host_if.v` even
  though you won't use AXI — the valid/ready reasoning is the same.
- **Digilent Basys3 reference manual + master XDC** — <https://digilent.com/reference/programmable-logic/basys-3/reference-manual>
  and <https://github.com/Digilent/digilent-xdc>. Verified pins for your board: `clk` W5 (100 MHz),
  `btnC` U18, UART `RsRx` B18 / `RsTx` A18, LEDs LD0..U15 start at U16,E19,U19,V19,W18,U15,U14,V14,V13,V3.
  *Why:* never trust recalled pin numbers — a wrong pin is a silent dead signal.

**Exit test:** an ILA or a register-file debug path that lets you see the state of a stalled FSM in one
build, rather than re-synthesising to add a probe.

### Tier A5 — Optional, only if you want the comparison (post-v2)

- **AMD UG1399 *Vitis HLS User Guide*** — <https://docs.amd.com/r/en-US/ug1399-vitis-hls>. *Why:* to write
  the "hand-written RTL vs HLS on the same network" section of the write-up. Not on the critical path.

### Do NOT spend time on

Vitis AI / DPU (Zynq UltraScale+ and Zynq-7000 with DDR only — an Artix-7 pure-PL part is not a supported
target), NVDLA (needs a big FPGA + DDR), FINN's supported flow (Zynq PS+DMA; Artix-7 use is community-hacked
— see `Xilinx/finn` discussion #508), float32 anywhere in hardware, or a 16×16 TPU-style systolic array as
v1. Build the 16-lane MAC array first; earn the systolic array in H5.

### Reading order

Wk 1–2 Kilts (pipelining, resource sharing) + Cummings; Wk 2–3 UG479 + UG473; Wk 3–4 Meyer-Baese (MAC,
systolic FIR) + UG901/UG906; Wk 4–6 Sze survey + the two MIT lectures with Person B; Wk 5–6 Eyeriss + TPU
papers + FINN docs. Everything else is lookup.

---

## §3 Toolchain setup (do this in week 1, before any design work)

- Vivado ML **Standard** — free, covers Artix-7 up to 100T, no license file. Install the Basys3 board files.
- Batch build flow (never the GUI for regressions): `vivado.bat -mode batch -source build_basys3.tcl`.
  Read `report_utilization` and `report_timing_summary` output files programmatically each build.
- Icarus + cocotb for simulation; GTKWave for waveforms.
- `openFPGALoader` or Vivado Hardware Manager for programming; kill stale serial readers (only one process
  can hold a COM port — a lingering Python reader makes working hardware look dead).
- Repo skeleton with `make sim`, `make synth`, `make prog`, `make regress` targets from day one.

---

## §4 Person A implementation plan

### H0 — Skeleton, loopback, and the baud ceiling (week 1)

Goal: prove the toolchain and measure the link before anything is designed around it.
- Repo skeleton; batch TCL build; blink; LED readout of a counter.
- `uart_tx.v` / `uart_rx.v` / `crc8.v` + a loopback FSM implementing OP `0x05`.
- **Measure your real maximum error-free baud over 10⁷ bytes** (FT2232H does up to 12 Mbaud; 1 Mbaud should
  be clean, validate it).
- Deliverable: `docs/latency.md` with the measured baud; loopback at the chosen rate.
- Exit: Person B's 40-line host script round-trips 10⁷ bytes with zero CRC errors.

### H1 — MAC, array, requant, against frozen vectors (weeks 2–3)

- `mac.v`: signed int8×int8→int32, 3 stages, valid/clear, no accumulation on invalid beats.
- `mac_array.v`: P=16 lanes + registered adder tree; verify the DSP count in the synthesis log.
- `requant.v`: shift, round-half-away-from-zero, saturate to uint8. **Test with the nasty values**: max/min
  int32, exact `.5` ties, negative values, saturation both ends.
- `relu.v`, `argmax.v` (lowest index on tie), `pool.v`.
- Deliverable: cocotb regression (written by Person B, run by you) passing 100% on these modules.
- Exit: every module byte-identical to the golden vectors, P=16, positive WNS at 100 MHz.

### H2 — Weight memory and the layer engine (week 4)

- `weight_bram.v`: `$readmemh` from `rtl/hex/`, absolute path via a `parameter INIT_FILE`.
  **Grep every synthesis log for `$readmem data file ... is read successfully`** — a wrong path is silent
  and gives you an all-zero ROM, which looks exactly like a math bug.
- `fc_engine.v`: FC layer as a dot-product loop over BRAM rows, one weight row per cycle, accumulator
  cleared per output neuron; `img_buffer.v` for the input image.
- Layer FSM: address generation, `valid` gating, done/busy, and a per-layer scale/shift taken from the
  register file (so Person B can retune scales without an RTL change).
- Exit: layer 1 of v1 matches Person B's `case_0000.l0.bin` byte-for-byte in simulation.

### H3 — Accelerator integration and host interface (week 5)

- `npu_top.v`: three layer engines chained, argmax, MMIO register file per §0.6.
- `host_if.v`: UART framer for OP `0x01`/`0x02`/`0x03`/`0x04`/`0x06`/`0x08`; write into `img_buffer` and
  the weight BRAMs; `0x07` DUMP_ACT behind a debug build flag.
- Integration choice: bare RTL host FSM (simplest, recommended for v1) **or** reuse your R32 RISC-V core as
  host with the NPU at `0x4000_0000` — you already have that MMIO pattern working on this board.
- Exit: full-network simulation matching all vectors; `GET_INFO` returns contract 1.0 / model id / P / clock.

### H4 — v1 on the board (weeks 6–7) — **first light**

- Program, load weights over UART (~51 KiB = 522 ms at 1 Mbaud, once per boot), send an image, read the
  result. Prediction on LEDs `LD3:0` and the 7-seg display; raw logits available over `READ_LOGITS`.
- Bring-up order that finds bugs fastest: LOOPBACK → GET_INFO → LOAD_WEIGHTS + status bit3 → START + busy →
  RESULT. Add a visible status register on the LEDs before you need it.
- Exit (this is the v1 project milestone): **20/20 of Person B's drawn digits classify identically to the
  golden model, on hardware.** Log utilisation and measured latency in `docs/`.

### H5 — The CNN engine at 50×50 (weeks 8–12) — the actual NPU, and the critical path

- `line_buffer.v`: 3-row circular buffer so one new pixel/cycle feeds a 3×3 window; **no im2col in memory**.
- `conv_engine.v`: weight-stationary, `Cout` filters spread across PEs, weights loaded once per layer,
  activations streamed; 9 taps is the natural inner dimension.
- Streaming 2×2 maxpool on the conv output; reuse `fc_engine.v` as an output-stationary tiled FC (1936→10).
- Accumulator width for 3×3×16 taps; then try the DSP48E1 **internal accumulator (MACC)** and the
  **pre-adder** to fold two window terms before the multiply — both are real LUT savings on a 35T.
- Revisit 200 MHz via MMCM only if you are throughput-starved after the 1 Mbaud link is saturated (you
  probably won't be — the system is link-bound).
- Exit: v2 CNN classifies on hardware, timing closed at the chosen clock, latency ≤ 500 µs, byte-exact
  against golden vectors.

### H6 — Performance, robustness, and the write-up (weeks 13–14)

- Full regression re-run against the final vectors; utilisation/timing/latency tables into `docs/`.
- Robustness: framing errors, CRC failure, mid-frame reset, weight reload while idle — error bit must be
  visible and recoverable, not a silent wedge.
- Optional stretch, only if the core is done: BNN variant (XNOR + popcount in LUTs instead of DSPs) for a
  comparison table, or a port to Arty A7-100T (same RTL, 2.7× BRAM, 240 DSP) in one TCL change.

---

## §5 JOINT WORK — sections that require Person A and Person B together

These are not "nice to sync up" items. Each one produces an artifact neither person can produce alone.

| ID | When | What | Deliverable / exit |
|---|---|---|---|
| **J0** | Week 1 | **Contract freeze.** Walk §0 line by line. Each person independently writes a CRC8 implementation and a frame parser; compare against 5 published test frames. Agree the register map, vector format, numeric spec, and the rule that changes are joint. | `CONTRACT.md` v1.0 committed, plus a shared `protocol_frames.txt` both parsers agree on. |
| **J1** | Weeks 3–5 | **Golden vector handoff.** B publishes vectors + the integer model; A runs them in cocotb. Every mismatch is diagnosed *together* — is it the RTL or the spec? This is where rounding bugs and accumulator-width bugs surface. | MAC/array/requant/layer regression at 100%, and a written note of every numeric discrepancy found and which side it was. |
| **J2** | Weeks 6–7 | **First-light bring-up session.** Both people at the board: A watches LEDs/ILA and reloads bitstreams, B runs the host driver and reports what the wire actually carried. Do not do the first hardware run of a real image alone. | 20/20 drawn digits match the integer model on hardware. |
| **J3** | Weeks 8–12, on every numeric change | **Change control on the contract.** If either person wants different bit widths, a per-channel scale, a new rounding mode, or an extra opcode: both agree, version bumps, B re-exports all vectors and hex, A re-runs the full regression. Nobody edits the contract silently. | Version-stamped `CONTRACT.md` + regenerated vectors + green regression. |
| **J4** | Monthly | **Accuracy ↔ throughput tradeoff review.** B brings the precision/accuracy table (int8 vs 4-bit vs 1-bit), A brings latency/utilization at each P. Decide *together* which point on the curve the project targets — this is an architecture decision, not either person's call. | A one-page decision record in `docs/tradeoffs.md` with the numbers that justified it. |
| **J5** | Weeks 13–14 | **Demo and write-up.** B's GUI/VGA assets and A's bitstream and measured numbers are one artifact. A supplies utilisation/timing/latency; B supplies accuracy/precision tables; both review the final report. | Final demo + report/README with numbers both people can defend. |

**Standing rule:** a "green" claim requires *A's regression log* AND *B's vector manifest SHA*. A bitstream
run with mismatched hashes is not evidence.

---

## §6 Interfaces: what you own vs. what you consume

| Interface | Owner | You must |
|---|---|---|
| `rtl/**`, `syn/**` (XDC, TCL), bitstream | **A** | change freely, but never break register map or frame format |
| `hex/*.hex`, `model.json`, `vectors/**` | **B** | treat as read-only input; report failures, don't patch |
| `sim/cocotb/**` | **B** writes, A runs | review the tests; you own the structural `tb_*.v` |
| Register map / UART ops / numeric spec (§0.4–0.6) | **joint** | change only via J3 |
| Contract version + SHA gate | **joint** | enforce it in your own flows |
| Latency/throughput budget, accuracy target | **joint** | A is accountable for latency, B for accuracy |

---

## §7 Things Person A must never do

- Hand-edit a `.hex` or a vector file to make a test pass.
- Change the register map, an opcode, or a rounding rule without J3.
- Claim a result from a bitstream whose `model.json` SHA doesn't match the vectors used in simulation.
- Trust a recalled pin number instead of the Digilent master XDC.
- Add a debug probe (sampled PC on LEDs, a mux) and forget to remove it — a restore that silently fails
  ships the debug display in the next bitstream and misreports the design's state. Grep for the debug
  signal names and confirm zero references before building.
- Report "it works" from utilisation/timing reports alone; only a hardware classification counts.

## §8 Risks specific to Person A

| Risk | Mitigation |
|---|---|
| Silent all-zero weight ROM | grep `read successfully` every build; assert a non-zero checksum of loaded weights in hardware |
| Accumulating on invalid beats | `valid` gating + a cocotb test that injects invalid beats mid-accumulation |
| Timing fails at 100 MHz | find the critical path in the routed report before reducing the clock — usually a wide mux or an unregistered BRAM output |
| BRAM over-budget when line buffers appear | budget 40/50 blocks from the start; the CNN needs ~5 for weights, the rest is buffers |
| Two builds disagree (GUI-held project lock) | build into a separate project dir; never delete/recreate a dir the GUI has open |
| Long debug loops | visible status register + UART as the debug channel from H0 onward |

## §9 Schedule (aligned with Person B's document)

| Week | Person A | Person B | Joint |
|---|---|---|---|
| 1 | H0 skeleton, loopback, baud measurement | S0 environment, contract, host driver stub | **J0** |
| 2–3 | H1 mac/array/requant | S1 dataset + own-code trainer | |
| 4 | H2 weight BRAM + layer engine | S2 quantiser + exporter | |
| 5 | H3 integration + host_if | S3 integer golden model + vectors | **J1** |
| 6–7 | H4 first light on board | S4 host driver + drawing GUI | **J2** |
| 8–9 | H5 line buffers + conv engine | S5 own-data collection + retrain | |
| 10–12 | H5 conv+pool+FC v2, timing closure | S6 benchmark harness, precision study | **J4** |
| 13–14 | H6 robustness + number tables | S7 demo assets, report sections | **J3, J5** |

Critical path: **H5**. Person B's work is front-loaded precisely so that A is never blocked waiting for
weights or vectors.
