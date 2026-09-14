# PERSON B — Software / AI / Training / Host Integration

**Role:** own everything between "an image exists" and "the right hex file + the host software exist".
Model design, training, numeric specification, quantisation, export, the integer golden model, the RTL
verification harness, and the host-side runtime.

**Mission:** produce a model that fits 225 KiB of BRAM and 90 DSPs, a bit-exact integer definition of it,
the `.hex` + `model.json` + test vectors that Person A's RTL is built against, and the PC software that
drives inference end to end.

**"Done" for this role** = a quantised model meeting the accuracy target, an integer model whose per-layer
outputs are byte-identical to hardware, a vector suite that gates Person A's regression, and a host
application where a person draws a digit and the answer comes back from the FPGA.

**Companion document:** `TEAM-A-hardware-fpga.md`. §0 (the contract) is identical in both files.

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

Rule that matters most: **rounding is round-half-away-from-zero, not floor, not banker's.** You implement
it in Python, Person A implements it in Verilog, and both have a unit test with negative and tie values.

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
  exponents, and the SHA-256 of every `.hex` file. Person A's RTL and your exporter both read it.
  **A run whose SHAs don't match the vectors is not evidence.**

### 0.4 Test vectors (the artifact that lets Person A work without you)

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

### 0.6 Register map (MMIO, on the device side — you consume it, you don't implement it)

| Offset | Name | Dir | Meaning |
|---|---|---|---|
| `0x000` | CTRL | W | bit0 start, bit1 soft reset, bit2 abort |
| `0x004` | STATUS | R | bit0 busy, bit1 done, bit2 error, bit3 weights loaded |
| `0x008` | RESULT | R | `[3:0]` argmax digit |
| `0x00C` | VERSION | R | `0x0001_0000` = contract 1.0 |
| `0x010` | IMG_WADDR | W | image byte address |
| `0x014` | IMG_WDATA | W | image byte |
| `0x018` | W_WADDR | W | weight byte address within `W_LAYER` |
| `0x01C` | W_DATA | W | weight byte |
| `0x020` | W_LAYER | W | layer id for weight writes |
| `0x030` | LOUT_ADDR | W | logit index 0..9 |
| `0x034` | LOUT_DATA | R | int32 logit |

### 0.7 Budgets (both people design to these)

| Quantity | Value | Consequence for you |
|---|---|---|
| Design clock | 100 MHz | latency targets below |
| Parallel MACs `P` | 16 (v1) → 32 (v2) | cycles = MACs / P |
| Inference latency | ≤ 1 ms (v1), ≤ 500 µs (v2) | your model must fit this MAC budget |
| Link throughput | ≥ 1 Mbaud = 2500 B in 25 ms | the system is **link-bound**: design accuracy, not speed |
| Accuracy | ≥ 98.5% MNIST test (v1), ≥ 98.5% on Person A's/HW's own drawings (v2) | your headline number |
| Weight storage | ≤ 40 of 50 BRAM blocks (5 KiB per block usable) | hard ceiling: this drives architecture choice |

---

## §1 Artifacts Person B owns

```
training/
  idx_loader.py        hand-parse raw MNIST IDX (no torchvision)
  data_aug.py          the exact preprocessing pipeline (shared with the drawing app)
  model.py             your own layers: Linear, Conv2d, ReLU, MaxPool, and their backward passes
  autograd.py          optional: your own tiny autograd (micrograd-style)
  train.py             training loop, own SGD/momentum, own LR schedule
  quantize.py          scale search, rounding, saturation, export
  export_hex.py        .hex + model.json (with SHAs)
  export_vectors.py    frozen test vectors + per-layer dumps
golden/
  npu_golden.py        bit-exact integer model of the hardware (the spec Person A builds to)
host/
  driver.py            pyserial framing, CRC8, retries, timeouts, benchmark mode
  draw_gui.py          drawing canvas, downsample, predict, save-sample
  webcam_demo.py       optional camera front-end
sim/cocotb/
  test_mac.py, test_requant.py, test_arrray.py, test_layer.py, test_full.py,
  test_protocol.py     vector-driven RTL regression (you write these, Person A runs them)
vectors/**             frozen test-vector suite
docs/
  accuracy.md, precision_table.md, latency_sw.md, tradeoffs.md (joint with A)
```

**Never edit `rtl/**`, `syn/**`, or a bitstream.** If the RTL is wrong, report it with a failing vector.

---

## §2 What Person B must learn

### Tier B1 — Neural networks from the math up, no framework (weeks 1–4)

You have chosen to write the ML code yourself. That is the right call here — you own every rounding
decision, so the float→fixed-point bridge is your design, not a library's. It also means you must
understand backprop deeply, not just call it.

- **Michael Nielsen, *Neural Networks and Deep Learning*** (free) — <http://neuralnetworksanddeeplearning.com/>.
  Code: `network.py` (141 lines) and `network2.py` (332 lines, **98.4% MNIST, pure Python, no NumPy**).
  *Why:* the canonical "write it yourself" path, and proof that a 300-line trainer reaches your accuracy
  target. Read every line of `network2.py`, then retype it from scratch.
- **Karpathy, `micrograd`** — <https://github.com/karpathy/micrograd> (autograd engine 94 lines, NN layers
  60 lines) plus his lecture *"The spelled-out intro to neural networks and backpropagation"*.
  *Why:* if you build your own autograd once, you never need PyTorch, and you'll never be confused about
  what a gradient is doing.
- **d2l.ai, *Dive into Deep Learning*** Ch. 3–7 — <https://d2l.ai/chapter_convolutional-neural-networks/>.
  *Why:* clear CNN/conv/pooling treatment; use the math, ignore the framework calls.
- **Stanford CS231n course notes** (free) — <https://cs231n.github.io/>. *Why:* convolution as matrix
  multiply, im2col, receptive fields, pooling arithmetic — the exact vocabulary you need to describe layers
  to Person A.
- **MNIST IDX format** — 4 big-endian uint32 header words (`[magic 2051, count, rows, cols]`, magic 2049 for
  labels) then raw uint8 payload. ~15 lines to parse. Files: ~11 MiB total.
- **OPTIONAL cross-check only:** PyTorch. Install it and use it *once* to confirm your hand-written trainer
  reproduces the same accuracy on the same data. Not a dependency, a sanity check.

**Exit test:** you have a from-scratch trainer for `784→64→32→10` and for the v2 CNN, with your own backward
passes, reaching ≥98.5% and ≥99% respectively, and you can hand-derive the gradient of a conv layer on
paper.

### Tier B2 — Fixed-point numerics and quantisation (weeks 3–6) — the highest-value tier

This is where your project either works or silently loses 30% accuracy.

- **Xilinx/AMD Brevitas** docs + examples — <https://github.com/Xilinx/brevitas>. *Why:* how
  quantisation-aware training is actually structured (fake-quant in the forward pass, straight-through
  gradient). Even hand-rolled, copy the *ideas*: quantise in the forward pass during fine-tuning, keep a
  float master copy of weights.
- **Randy Yates, *Fixed-Point Arithmetic: An Introduction*** (freely available write-up). *Why:* the
  Q-format language both you and Person A must share: integer vs fractional bits, scaling, and why the
  accumulator width is `operand widths + log2(number of terms)`.
- **PyTorch quantisation recipe** — <https://docs.pytorch.org/tutorials/recipes/quantization.html> and
  *Introduction to Quantization on PyTorch* — *Why:* read for the concepts (per-tensor vs per-channel,
  calibration, PTQ vs QAT), not the API.
- **MIT 6.5940, *TinyML and Efficient Deep Learning Computing*** — the quantisation and pruning lectures,
  <https://hanlab.mit.edu/courses>. *Why:* best free treatment of how low you can push precision and what
  it costs in accuracy.
- **Sze et al., *Efficient Processing of Deep Neural Networks* (survey: arXiv:1703.09039)** — the
  quantisation and dataflow sections. *Why:* gives you the hardware consequence of every numeric choice,
  which is what makes you a useful partner to Person A.
- **Xilinx WP486, *Deep Learning with INT8 Optimization on Xilinx Devices*** —
  <https://docs.amd.com/v/u/en-US/wp486-deep-learning-int8>. *Why:* the vendor's int8 framing; also the
  justification for picking int8 as the primary precision.
- **XNOR-Net / BinaryConnect / DoReFa-Net** papers. *Why:* the 1-bit end of the ladder, for the precision
  ablation table Person A wants for §J4.

**Exit test:** you can produce, for the same model, an accuracy table at fp32 / int8 / 4-bit / 1-bit, explain
the accuracy loss at each step, and compute from first principles the minimum accumulator width for any
layer. You can state the per-layer scales as exponents and justify each one.

### Tier B3 — Verification and RTL literacy (weeks 4–8, you're the verification engineer)

You do not need to design hardware, but you must read it and you will write every test that gates it. In a
two-person project this is the natural split: Person A designs, you verify.

- **cocotb docs** — <https://docs.cocotb.org/> *Why:* your testbenches; you'll be driving Person A's modules
  from Python and diffing against your integer model.
- **The basics of reading Verilog** — clocked `always` blocks, nonblocking assignment, `valid`/`ready`
  handshakes, an FSM's state register. Enough to answer "is this the RTL or my vector?" — the single most
  useful skill in a two-person hardware project.
- **Person A's companion doc §0 and §2 (Tier A2)** — read their UG479/UG473 tier notes so you know what a
  DSP48E1 and a BRAM block actually are. You're negotiating with someone whose constraints are physical.
- **The two Basys3 reference repos** — `adithyarg/MLP-Accelerator-for-MNIST-on-Basys3-FPGA`
  (`training/train.py` 69 lines, `quantize.py` 75 lines, `host/webcam_detect.py` 136 lines) and
  `sharatchandra-ts/systolic-TPU-CNN-accelerator` (`data_loader.py` 12, `export.py` 41, `model.py` 27,
  `train.py` 39 lines). *Why:* two complete, working software halves of exactly your problem, totalling
  ~280 and ~135 lines. Read them for structure, then write yours (you're going framework-free, they use
  PyTorch — take the file layout and the export format ideas).

**Exit test:** you can look at a failing cocotb log and say which side of the contract is violated, and
you've caught at least one real bug in Person A's RTL with a vector.

### Tier B4 — Host software and the data domain (weeks 5–10)

- **pyserial docs** — <https://pyserial.readthedocs.io/>. Frames, timeouts, retries, and how to raise the
  baud; on Windows `pyserial` is the only sane transport. Note: serial ports are exclusive — a stale reader
  makes working hardware look dead, so your driver must fail loudly.
- **Tkinter + Pillow** (drawing canvas, downsampling with `Image.LANCZOS`/nearest) or **OpenCV**
  (`cv2.resize`, webcam capture) — pick one; Tkinter/Pillow is lighter for a drawing app.
- **Google Quick, Draw! dataset** — <https://github.com/googlecreativelab/quickdraw-dataset>. *Why:* 50M
  drawings as 28×28 grayscale bitmaps, free, a far broader drawing distribution than MNIST; the antidote to
  domain shift when the model meets a person drawing on a canvas.
- **EMNIST** — <https://www.nist.gov/itl/products-and-services/emnist-dataset>. *Why:* optional later
  extension to letters.
- **Dataset bytes are small:** MNIST is 11 MiB; a full 50×50 uint8 dataset is 175 MB. Store uint8, augment
  on the fly — an upscaled float32 copy in RAM is 600 MB and you don't need it. Training the float models
  once and caching the int8 test-set inputs is all you need for the regression.

**Exit test:** `host/driver.py` can send 10⁷ bytes and report CRC/loss statistics; `draw_gui.py` can save
labelled samples into the training format in one click.

### Do NOT spend time on

Training an LLM, ONNX/TFLite/ONNX Runtime, `torchvision.datasets` (you're parsing IDX yourself),
Vitis AI / DPU toolchains, FINN's supported flow (Zynq-only), GPU setup (the biggest model here is
165 Gop — a CPU finishes the whole run in under an hour with NumPy-backed arithmetic), or reaching for
fp32 accuracy in hardware.

### Reading order

Wk 1–2 Nielsen + micrograd (retype both); Wk 2–3 d2l Ch. 5–7 + CS231n notes; Wk 3–5 Yates fixed-point +
MIT 6.5940 quantisation lectures + Brevitas ideas; Wk 4–6 Sze survey + WP486; Wk 5–8 cocotb + reading
Verilog; Wk 6–10 pyserial + the drawing/camera app.

---

## §3 Toolchain setup (week 1)

- Python 3.11+, `numpy`, `pyserial`, `Pillow` (or `opencv-python`), `matplotlib` for plots, `cocotb` for the
  RTL tests, `pytest` to drive your own unit tests. Optional, cross-check only: `torch`.
- One `make`-style entry point: `make data`, `make train`, `make quantise`, `make vectors`, `make host`,
  `make regress` (regress calls Person A's simulator through cocotb).
- Repo skeleton per §1; commit the contract document in week 1 so the contract is versioned, not remembered.

---

## §4 Person B implementation plan

### S0 — Environment, contract, transport stub (week 1)

- Install deps; write `idx_loader.py`; verify you can read and display an MNIST image without any framework.
- Implement CRC8 + the frame encoder/decoder **from the contract text alone**, without looking at Person A's
  code — then compare with theirs at J0. Two independent implementations agreeing is the point.
- `host/driver.py` skeleton with `loopback(n_bytes)` and a bit-error/loss report.
- Deliverable: `CONTRACT.md` committed; CRC8 unit test with published test frames; loopback bench.
- Exit: 10⁷ bytes round-tripped through Person A's BOARD at the agreed baud with zero CRC errors.

### S1 — Your own trainer (weeks 2–3)

- `model.py`: `Linear`, `ReLU`, `Conv2d`, `MaxPool2d`, forward and backward, written by you.
- `autograd.py` (optional path): micrograd-style `Value`/tensor with `backward()`, then a thin module layer.
- `train.py`: your own SGD + momentum, LR schedule, mini-batches, deterministic seeding, checkpointing.
- `data_aug.py`: the **exact** preprocessing the hardware will see — this file is later shared with the
  drawing app so training and inference cannot diverge.
- Train v1 (28×28 MLP) and v2 (50×50 CNN). Expected wall-clock: v1 in minutes, v2 in under an hour with
  vectorised array math (or ~5 h/epoch if you insist on pure scalar Python — acceptable for v1's overnight
  run, not for v2's iteration loop).
- Exit: ≥98.5% (v1) and ≥99% (v2) in float; checkpoints reproducible from a seed.

### S2 — Quantiser and exporter (week 4)

- `quantize.py`: scale search (min/max or percentile calibration), **power-of-two scales only**, int8
  weights, uint8 activations, int32 biases pre-scaled into accumulator units, per-layer shift exponents.
- Rounding: round-half-away-from-zero, then saturate. Every one of those three behaviours gets a unit test
  with negative values and exact ties — the same test Person A writes in Verilog.
- Optional QAT pass: quantise in the forward loop, fine-tune, recover the lost accuracy (expect 0.5–2%
  recovery; this is where Brevitas' *ideas* earn their keep).
- `export_hex.py`: `.hex` files + `model.json` with SHA-256 per file and the scales as exponents.
- Exit: quantised accuracy within ~0.5% of float, weights ≤ 5 KiB per 1000 params check, **v2 weights fit in
  ≤ 5 BRAM blocks (20 KiB)**, and the SHA manifest generates deterministically.

### S3 — The integer golden model and vectors (week 5) — the spec Person A builds to

- `golden/npu_golden.py`: a bit-exact integer re-implementation — fixed widths, fixed rounding, saturation,
  shift-based requantisation, no floating point anywhere in the path. This is not a "reference model", it is
  **the definition of correct**.
- Verify it reproduces its own quantised accuracy on the full test set (if the integer model can't hold
  accuracy, no RTL ever will).
- `export_vectors.py`: N cases (start with 32, grow to 512) with per-layer activation dumps, int32 logits,
  and argmax; positive cases, adversarial cases (all-black, all-white, ties, saturation edges, max/min
  accumulator values).
- Exit: `vectors/manifest.json` frozen, SHAs recorded, and you can explain every dump byte by hand.

### S4 — Host runtime and the drawing app (weeks 6–7)

- `driver.py` complete: LOAD_WEIGHTS (with progress), LOAD_IMG, START, GET_RESULT, READ_LOGITS, retries,
  timeouts, and a `--benchmark N` mode that reports per-inference latency and accuracy on the test set.
- `draw_gui.py`: canvas → the same preprocessing module as training → LOAD_IMG → result displayed, with a
  "save sample + label" button (this button is how you build the v2 dataset).
- Exit at J2: 20/20 drawn digits match the golden model, and the GUI is good enough that a stranger can use
  it without instructions.

### S5 — Own-dataset collection and retrain (weeks 8–9) — the domain-shift fix

- Collect 300–1000 of your own drawings (plus Person A's), deliberately varied in stroke width, size,
  centring, and sloppiness. Add Quick, Draw! bitmaps upscaled to 50×50.
- Retrain v2 with the mixed distribution, re-quantise, re-export, re-verify the integer model, hand new
  vectors to Person A (this is a J3 event).
- Exit: ≥98.5% on the held-out **own-drawings** test set, not just MNIST. Report both numbers separately.

### S6 — Benchmarks, precision study, and the tradeoff record (weeks 10–12)

- Precision ablation: fp32 / int8 / 4-bit / 2-bit / 1-bit — accuracy, weight size in BRAM blocks, and
  whether the MAC structure changes (binary needs XNOR+popcount, not DSPs).
- End-to-end measurements: baud, frame time, FPGA latency, inferences/s, and the honest statement that the
  system is link-bound.
- Feed Person A the numbers for the J4 tradeoff decision.
- Exit: `docs/precision_table.md` + `docs/accuracy.md` complete enough that the tradeoff record is one page.

### S7 — Demo polish and the write-up (weeks 13–14)

- VGA/display assets (whichever side displays the 50×50 image beside the prediction), README, and the
  accuracy/latency/precision tables that go in the final report.
- Prove reproducibility for the write-up: `make data && make train && make quantise && make vectors && make regress`
  from a clean checkout reproduces the frozen SHAs.
- Exit (with J5): the demo runs from a fresh clone, and every number in the report is regenerable.

---

## §5 JOINT WORK — sections that require Person A and Person B together

These are not "nice to sync up" items. Each one produces an artifact neither person can produce alone.

| ID | When | What | Deliverable / exit |
|---|---|---|---|
| **J0** | Week 1 | **Contract freeze.** Walk §0 line by line. Each person independently writes a CRC8 implementation and a frame parser; compare against 5 published test frames. Agree the register map, vector format, numeric spec, and the rule that changes are joint. | `CONTRACT.md` v1.0 committed, plus a shared `protocol_frames.txt` both parsers agree on. |
| **J1** | Weeks 3–5 | **Golden vector handoff.** You publish vectors + the integer model; Person A runs them in cocotb. Every mismatch is diagnosed *together* — is it the RTL, or the spec? You own the question "which side is wrong", and you must be willing to find that your spec was ambiguous. | MAC/array/requant/layer regression at 100%, and a written note of every numeric discrepancy found and which side it was. |
| **J2** | Weeks 6–7 | **First-light bring-up session.** Both people at the board: Person A reloads bitstreams and watches LEDs/ILA, you run the host driver and report what the wire actually carried. Never debug a first hardware run from one side of the desk. | 20/20 drawn digits match the integer model on hardware. |
| **J3** | Weeks 8–12, on every numeric change | **Change control on the contract.** If you want different bit widths, per-channel scales, a new rounding mode, or an extra opcode: both agree, version bumps, you re-export all vectors and hex, Person A re-runs the full regression. This is why you must never "just tweak the quantiser" late in the project. | Version-stamped `CONTRACT.md` + regenerated vectors + green regression. |
| **J4** | Monthly | **Accuracy ↔ throughput tradeoff review.** You bring the precision/accuracy table, Person A brings latency/utilization at each P. Decide *together* which point on the curve the project targets — it changes your model and their array, so neither person can choose alone. | A one-page decision record in `docs/tradeoffs.md` with the numbers that justified it. |
| **J5** | Weeks 13–14 | **Demo and write-up.** Your GUI/assets and Person A's bitstream and measured numbers are one artifact. You supply accuracy/precision tables and the reproducible build; Person A supplies utilisation/timing/latency; both review the final report. | Final demo + report/README with numbers both people can defend. |

**Standing rule:** a "green" claim requires *Person A's regression log* AND *your vector manifest SHA*.
A hardware run with mismatched hashes is not evidence.

---

## §6 Interfaces: what you own vs. what you consume

| Interface | Owner | You must |
|---|---|---|
| `hex/*.hex`, `model.json`, `vectors/**` | **B (you)** | publish with SHAs; never publish an unversioned change |
| `training/**`, `golden/**`, `host/**` | **B (you)** | change freely |
| `rtl/**`, `syn/**`, bitstream | **A** | consume only; report failures with a failing vector, never patch the RTL |
| `sim/cocotb/**` | **B writes, A runs** | your tests are the project's regression gate |
| Register map / UART ops / numeric spec (§0.4–0.6) | **joint** | change only via J3 |
| Contract version + SHA gate | **joint** | enforce it in your export flow (refuse to export without updating `model.json`) |
| Latency budget | **A** is accountable | you supply the MAC budget and the model that fits it |
| Accuracy target | **B** is accountable | you must say which dataset the number is on |

---

## §7 Things Person B must never do

- Publish a `.hex` or vector set without updating `model.json` and its SHAs.
- Change a bit width, a rounding rule, or a scale convention without J3 — a silent quantiser change
  invalidates every regression Person A has run.
- Edit RTL to make a test pass. Report the failure with the failing vector instead.
- Report accuracy on the training set, or on MNIST only, when the claim is about hand-drawn input.
- Let the drawing app's preprocessing diverge from `data_aug.py` — that is how a 98% model becomes a 60%
  model the day it meets a real person's handwriting.
- Use rounding that differs from the contract for "convenience" (`numpy.round` is banker's rounding — this
  is the single most likely silent accuracy bug in the project).
- Claim a hardware result without the matching bitstream SHA.

## §8 Risks specific to Person B

| Risk | Mitigation |
|---|---|
| Float model is fine, integer model loses accuracy | verify the integer model on the full test set *before* RTL exists; tune scales, then add QAT |
| Rounding mismatch Python vs Verilog | shared unit test with negative/tie inputs; treat as a contract test, not an implementation detail |
| Accumulator overflow in hardware only | compute worst-case widths per layer and publish them in `model.json`; include saturation-edge vectors |
| Domain shift (MNIST vs your drawings) | own-dataset collection (S5) with the exact production preprocessing; report both numbers |
| A 2500-input MLP that can't fit 225 KiB | architecture decision is already made: conv front-end (20 KiB) at 50×50 |
| Training wall-clock kills iteration | use vectorised array math; expensive ablations (1-bit, QAT) run once, on cached features |
| Contract drift over months | versioned `CONTRACT.md` + SHA gate + J3 on every numeric change |

## §9 Schedule (aligned with Person A's document)

| Week | Person B | Person A | Joint |
|---|---|---|---|
| 1 | S0 environment, contract, transport stub | H0 skeleton, loopback, baud measurement | **J0** |
| 2–3 | S1 own trainer (v1 + v2) | H1 mac/array/requant | |
| 4 | S2 quantiser + exporter | H2 weight BRAM + layer engine | |
| 5 | S3 integer golden model + vectors | H3 integration + host_if | **J1** |
| 6–7 | S4 host driver + drawing GUI | H4 first light on board | **J2** |
| 8–9 | S5 own-data collection + retrain | H5 line buffers + conv engine | |
| 10–12 | S6 benchmarks + precision study | H5 conv+pool+FC v2, timing closure | **J4** |
| 13–14 | S7 demo assets, report sections | H6 robustness + number tables | **J3, J5** |

You are deliberately front-loaded: Person A must never be blocked waiting for weights or vectors, and every
numeric decision that could invalidate their regression must be made before their H5 (the critical path)
begins.
