# Handwritten-Digit NPU on a Basys3 (Artix-7 XC7A35T) — Research + Build Roadmap

Target: a custom NPU in RTL on the Basys3, classifying hand-drawn digits that the user draws at ~50x50,
with the model trained locally (PyTorch) and quantized to fixed-point for the fabric.

---

## 0. Verdict

**Feasible.** Not "feasible with heroics" — comfortably feasible, and the textbook third-project for
someone with your background (Verilog, cocotb, Vivado, RISC-V soft core already working on this board).

The three things that actually gate this project, in order:

1. **Engineering time** (the real cost — a CNN engine is ~2–4 months of part-time work for a first build).
2. **Input transport** (UART), not compute. A 50x50 frame = 2500 bytes; at 115200 baud that is 217 ms/frame
   → ~5 inferences/s end-to-end. Compute is ~100 us. Your accelerator will be idle 99.8% of the time at
   default baud. Fix by raising baud (FT2232H bridge does 1–3 Mbaud easily) or by streaming a stored test set.
3. **Weight storage in BRAM** (225 KiB total, 50 x 36Kb blocks) — this is what forces your quantisation
   and architecture decisions, and it is the one hard number to design around.

Compute is *not* a problem: 90 DSP48E1 (25x18 multiplier + 48-bit accumulator + pre-adder) at 100 MHz
gives you 9 GMAC/s if you use all 90. MNIST-class models need ~0.05–1 MMAC per inference.

---

## 1. Hardware envelope (verified)

| Resource | XC7A35T-1CPG236C (Basys3) |
|---|---|
| Slices / LUT6 / FF | 5,200 / 20,800 / 41,600 (Digilent: "33,280 logic cells") |
| DSP slices | 90 x DSP48E1 (25x18 signed mult, 48-bit accumulate, pre-adder) |
| Block RAM | 1,800 Kb = 225 KiB = 50 x 36Kb RAMB36E1 (byte-wide mode: 4 KiB usable per block) |
| Clocking | 5 CMT (PLL/MMCM); board oscillator 100 MHz on pin W5 |
| External memory | **none** (no DDR) — weights must live in BRAM/LUT ROM |
| Storage | 32 Mbit (4 MB) QSPI flash (configuration + spare space for a small dataset) |
| Host I/O | USB-UART bridge FT2232H (up to 12 Mbaud; 115200 default) |
| Display | 4-digit 7-seg, 16 LEDs, 16 switches, 5 buttons, 12-bit VGA |
| Expansion | 3 Pmod + 1 XADC Pmod |

Upgrade path if you outgrow it: Arty A7-100T (XC7A100T: 15,850 slices / 4,860 Kb BRAM / 240 DSP) —
same RTL, same flow, 2.7x BRAM. Pynq-Z2/Zybo adds an ARM + DDR, which is what the *finished*
toolchains (FINN, Vitis AI DPU) actually require.

---

## 2. The arithmetic of your specific problem

**50x50 input is the risky part, and it is not the compute — it is the first layer's weights.**

A fully-connected first layer on 2,500 inputs blows the BRAM budget at int8:

| Model | Params | Weights @8-bit | BRAM blocks | Verdict |
|---|---|---|---|---|
| MLP 2500-128-64-10 | 329,034 | 321 KiB | 80 / 50 | **does not fit** |
| MLP 2500-128-64-10 @4-bit | 329,034 | 161 KiB | 40 / 50 | fits, tight |
| MLP 2500-128-64-10 @1-bit (BNN) | 329,034 | 40 KiB | 10 / 50 | fits easily |
| MLP 784-64-32-10 @8-bit (28x28) | 52,650 | 51 KiB | 13 / 50 | fits easily |
| **CNN 50x50** (3x3 1→8, pool, 3x3 8→16, pool, FC→10) | 20,618 | **20 KiB** | 5 / 50 | fits with room to spare |

The same CNN needs **862,912 MACs/inference** — 26,966 cycles at 32 MACs/cycle (~270 us at 100 MHz,
~3,700 inf/s). So the conv front-end costs you compute you have in abundance and saves you the memory you
don't. **Conclusion: do not build a 2500-input MLP. Build a small CNN, or use ≤4-bit weights.**

Latency vs parallelism (100 MHz), for planning:

| Model | MACs | P=8 | P=32 | P=64 | P=81 |
|---|---|---|---|---|---|
| MLP 784-64-32-10 @8b | 52,544 | 66 us | 16 us | 8 us | 6.5 us |
| CNN 50x50 @8b | 862,912 | 1,079 us | 270 us | 135 us | 107 us |

Even an 8-MAC design (8 DSPs, 9% of the device) beats the UART link. **P=16–32 is the sane first target**,
leaving DSPs free and keeping the adder trees easy to close timing on.

Input transport budget (2500 bytes + 1 byte result, 10 bit-times/byte):

| Baud | Frame time | End-to-end cap |
|---|---|---|
| 115,200 | 217 ms | 5 inf/s |
| 921,600 | 27 ms | 37 inf/s |
| 1,000,000 | 25 ms | 40 inf/s |
| 3,000,000 | 8.3 ms | 120 inf/s |

**Pick 1 Mbaud as the project target** (works reliably over the FT2232H with pyserial `115200*8`-style
constant rates; verify loopback on day one).

---

## 3. Bottlenecks, ranked

1. **Your own time / debugging surface.** Full-custom RTL CNN engines are where most hobby projects die.
   Mitigate with: layer-by-layer bit-exact verification against PyTorch, intermediate-activation dumps,
   and a v1 that has *no convolution at all* (see Phase 4).
2. **UART throughput** (see above).
3. **BRAM** (see above).
4. **Timing closure** at 100 MHz for wide adder trees / big muxes. Mitigate with DSP internal accumulation,
   pipelining registers between stages, and `P` kept modest.
5. **Domain shift in accuracy** — MNIST is 28x28; your 50x50 drawings are a different distribution.
   This is a *data* problem, not a hardware problem: build the drawing app early and collect your own samples
   in the exact preprocessing pipeline the hardware uses.

---

# PART 1 — What to learn

## Tier 1 — Neural networks, from the math up (~3 weeks)

You must be able to derive backprop by hand and implement conv/FC/ReLU/pool in NumPy *without a framework*.
If you can't do it in NumPy, you can't design hardware for it.

- **Michael Nielsen, *Neural Networks and Deep Learning*** (free online) — backprop, gradient descent, MNIST.
  http://neuralnetworksanddeeplearning.com/
- **d2l.ai, *Dive into Deep Learning*** Ch. 3–7 (linear nets → MLPs → CNNs), with the PyTorch tab.
  https://d2l.ai/chapter_convolutional-neural-networks/
- **Stanford CS231n course notes** (free) — convolution as matrix multiply, im2col, receptive fields, pooling.
  https://cs231n.github.io/
- **PyTorch 60-min blitz + `torchvision`** — you need to train, save, and export weights confidently.

Output check: a PyTorch model that hits ≥99% MNIST, plus a NumPy reimplementation whose logits match the
framework's to <1e-5.

## Tier 2 — DNN accelerator architecture (~4 weeks) — the most important tier

- **Vivienne Sze, Yu-Hsin Chen, Tien-Ju Yang, Joel Emer, *Efficient Processing of Deep Neural Networks***
  (Morgan & Claypool / Springer, Synthesis Lectures on Computer Architecture). THE reference: dataflow
  taxonomy (weight-stationary / output-stationary / row-stationary), loop unrolling & tiling, PE arrays,
  memory hierarchy, energy-vs-throughput analysis.
  Free precursor paper: *Efficient Processing of Deep Neural Networks: A Tutorial and Survey*,
  arXiv:1703.09039 — read this first, then buy/borrow the book.
- **MIT 6.5940 / 6.S965, *TinyML and Efficient Deep Learning Computing*** (Song Han) — free lecture videos,
  slides, and 5 labs: pruning, quantization, neural architecture search, hardware accelerators.
  https://hanlab.mit.edu/courses — the "Hardware Acceleration" + "Quantization" lectures are directly on point.
- **Stanford CS217, *Hardware Accelerators for Machine Learning*** (Olukotun/Pedram) — lecture material on
  systolic arrays, dataflows, roofline.
- Papers worth reading properly (they are the vocabulary of this field):
  - Kung, "Why Systolic Architectures?" (1982) — the origin.
  - Chen et al., **Eyeriss** (ISCA 2016) — dataflow and energy per MAC.
  - Jouppi et al., **TPU** (ISCA 2017) — systolic array at scale.
  - Umuroglu et al., **FINN** (FPGA 2017) — binarized NN dataflow on FPGA.
  - Courbariaux et al. **BinaryConnect**; Rastegari et al. **XNOR-Net**; Zhou et al. **DoReFa-Net** —
    1-bit weights/activations and how accuracy survives.
  - Sze et al. survey above, plus Guo et al., *A Survey of FPGA-Based Neural Network Accelerators*
    (arXiv:1712.08934) and Yan/Koch/Sinnen, *A Survey on FPGA-based Accelerators for ML Models*
    (arXiv:2412.15666, 2024 — the most current map of the field).
- Practical, blog-level: **Adam Taylor's "MicroZed Chronicles"** series on neural networks on FPGA
  (search "MicroZed Chronicles neural network"), and **Xilinx WP486 *Deep Learning with INT8 Optimization
  on Xilinx Devices*** for the vendor view of int8 on DSP48.

Output check: you can look at a network and, without a tool, say whether it fits in 225 KiB and how many
cycles it takes at a given parallelism, and which dataflow you'd pick.

## Tier 3 — FPGA design for compute, not just logic (~4 weeks)

- **Steve Kilts, *Advanced FPGA Design: Architecture, Implementation, and Optimization*** — pipelining,
  resource sharing, area/speed tradeoffs, clock domain crossing, coding for synthesis. Exactly the book for
  "build a datapath", not "write a state machine".
- **Uwe Meyer-Baese, *Digital Signal Processing with Field Programmable Gate Arrays*** — MAC design,
  pipelining, systolic FIR structures, distributed arithmetic. The arithmetic architecture foundations;
  a convolution engine is a 2-D FIR filter wearing a hat.
- **Pong P. Chu, *FPGA Prototyping by Verilog Examples*** — reference designs for BRAM, FSMs, datapaths.
- **Harris & Harris, *Digital Design and Computer Architecture*** — if you want the textbook treatment of
  FP ALUs/FSM/datapath design to go with your existing RISC-V knowledge.
- Vendor docs you will actually open: **UG479 (DSP48E1)**, **UG473 (7-Series Memory Resources)**,
  **UG901 (Synthesis)**, **UG903 (Constraints)**, **UG949 (Methodology)**, **UG906 (Timing Analysis)**.
- **ZipCPU tutorial + blog** (zipcpu.com/tutorial) — FSM/datapath style, AXI handshaking, verification mindset.
- **Cliff Cummings' papers** (nonblocking assignments, coding guidelines) — the cheap way to avoid the classic
  simulation/synthesis mismatches.

Output check: a parameterized, pipelined MAC + a BRAM-based weight buffer + a clean FSM, each with a cocotb
testbench, timing closed at 100 MHz, resource reports read and understood.

## Tier 4 — Quantisation & fixed-point numerics (~2 weeks) — where accuracy is won or lost

- **Xilinx/AMD Brevitas** (PyTorch quantisation-aware training, the front end of FINN) — docs + examples:
  https://github.com/Xilinx/brevitas
- **QKeras / hls4ml** docs for the "quantise then emit hardware" mindset:
  https://fastmachinelearning.org/hls4ml/
- **PyTorch quantization recipe** (PTQ + QAT) — https://docs.pytorch.org/tutorials/recipes/quantization.html
  and the classic *Introduction to Quantization on PyTorch* blog post.
- Key concepts to own: scale/zero-point, per-tensor vs per-channel scales, affine vs symmetric,
  **power-of-two scales so requantisation is a shift instead of a multiplier**, round-half-away-from-zero
  + saturation (must match your hardware exactly or accuracy silently degrades), accumulator width sizing
  (int8 x int8 x N needs log2(N)+16 bits), and the accuracy ladder: fp32 ~99.2%, int8 ~99.0%,
  4-bit ~98.5%, 2-bit ~97%, 1-bit (BNN) ~95–97% with QAT.

Output check: same model, four precisions, accuracy table, and a bit-exact fixed-point simulator in NumPy.

## Tier 5 — Integration & verification (learning by doing, throughout)

- **cocotb** (you have it) for RTL testbenches driven by your NumPy golden model.
- **UART framing / handshake protocol** design + a Python host driver (`pyserial`) + a drawing GUI
  (Tkinter/PIL, `pygame`, or `opencv-python` for webcam).
- **Vivado batch TCL** builds (project already in your workflow).
- Optional: **Vitis HLS (UG1399)** — a legitimate second path where you write C++ and let the tool pipeline
  it. Useful for *comparison* and to understand what good scheduling looks like, but the learning (and the
  resume/portfolio value) is in writing the RTL.

## Do-NOT-waste-time list

- **Float32 anywhere in the hardware.** 90 DSPs cannot express fp32; fixed-point is the whole game.
- **Vitis AI / DPU** — DPUCZDX8G targets Zynq UltraScale+/Zynq-7000 with DDR; a pure-PL Artix-7 part is not a
  supported target. (Same for NVDLA — needs a big FPGA + DDR.)
- **FINN on Artix-7** as your first path — FINN's supported flow assumes Zynq boards with PS+DMA; Artix-7
  use is community-hacked (see Xilinx/finn discussion #508). Learn from FINN's ideas; build your own RTL.
- **A 16x16 TPU-style systolic array as v1.** You'd spend months on skew buffers and im2col before you ever
  see a digit classified. Earn it in Phase 5.
- **Trying to beat a GPU/MCU on throughput.** The point is building the machine, not winning a benchmark.
- **Training on MNIST and assuming your own drawings will classify.** Fix the data domain (Phase 6).

## Suggested reading order (10 weeks part-time)

1. Wk 1–3: Nielsen + d2l Ch. 4–6 + CS231n notes → NumPy CNN from scratch.
2. Wk 3–5: Sze survey paper → MIT 6.5940 quantisation + hardware lectures → Eyeriss + TPU papers.
3. Wk 5–8: Kilts + Meyer-Baese (chapters on MAC/pipelining/systolic) + UG479/UG473 → pipelined MAC in RTL.
4. Wk 8–10: Brevitas docs + PyTorch quantisation recipe + WP486 → quantise your model to int8 and prove the
   accuracy holds. Start Phase 0/1 of the build plan in parallel from week 3.

---

# PART 2 — End-to-end implementation plan

Repo layout (create it first; it survives every toolchain change):

```
npu-basys3/
├── training/       # PyTorch: model, train.py, quantise.py, export_weights.py
├── golden/         # NumPy bit-exact simulator (the contract the RTL must match)
├── rtl/
│   ├── compute/    # mac.v, mac_array.v, requant.v, relu.v, argmax.v, pool.v, conv_engine.v
│   ├── memory/     # weight_bram.v, img_buffer.v, line_buffer.v
│   ├── io/         # uart_rx.v, uart_tx.v, host_if.v (protocol FSM)
│   ├── npu_top.v   # accelerator core + control FSM
│   ├── top_basys3.v
│   └── hex/        # exported weight/bias hex files
├── sim/            # cocotb tests + testbenches
├── syn/            # basys3.xdc, build_basys3.tcl
├── host/           # python uart driver, drawing app, webcam demo
└── docs/           # per-phase results: utilisation, timing, accuracy, latency
```

## Phase 0 — Environment & loop (a weekend)

Goal: prove the whole toolchain before designing anything interesting.
- Vivado ML Standard (free; Artix-7 up to 100T supported), Digilent board files + master XDC
  (https://github.com/Digilent/digilent-xdc).
- Blink + UART loopback on the board: PC sends 8 bytes, FPGA echoes them. **Establish the max baud you can
  run error-free for 10^7 bytes** — this number sets your whole system's throughput.
- cocotb + Icarus/Verilator running one trivial test.
Done when: bitstream programmed, loopback verified at your target baud (aim 1 Mbaud), and a cocotb test
runs from the command line.

## Phase 1 — Software golden model + quantiser (1–2 weeks)

Goal: a model that fits the device and an export pipeline you trust.
- Decide architecture. Recommended: `conv3x3(8) → ReLU → maxpool2 → conv3x3(16) → ReLU → maxpool2 → FC(10)`
  on 50x50 → 20 KiB weights, 863K MACs. Optional MLP fallback at 28x28 (`784-64-32-10`) if you want a
  trivial first target.
- Train in PyTorch on MNIST upscaled to 50x50 (and/or Google Quick, Draw! 28x28 bitmaps,
  https://github.com/googlecreativelab/quickdraw-dataset — 50M drawings, free, npy/28x28).
- Quantise: int8 weights, uint8 activations, int32 accumulators, **per-tensor power-of-two scales**.
  Export `weights.hex`/`biases.hex` (`$readmemh`-compatible), plus a JSON manifest of every scale.
Done when: quantised accuracy is within ~0.5% of fp32 and weights fit in ≤10 BRAM blocks (documented in
`docs/`).

## Phase 2 — Bit-exact NumPy "hardware model" (1 week)

Goal: the specification the RTL is verified against — *not* a floating-point model.
- Implement the exact integer dataflow in NumPy: fixed widths, fixed rounding (round-half-away-from-zero),
  saturation, shift-based requantisation, shift-add only where the hardware will.
- Generate frozen test vectors: input image bytes → per-layer activation dumps → logits → argmax.
Done when: `golden/vectors/` contains N test cases with per-layer intermediates, and the quantised
accuracy claim is reproduced by this integer model. **This step is what makes the RTL debuggable.**

## Phase 3 — RTL building blocks, bottom-up with cocotb (2–4 weeks)

Order (each one gets a testbench that compares against the golden model, bit-exactly):
1. `mac.v` — signed int8 x int8, int32 accumulate, valid/clear, 1–3 pipe stages. Check DSP inference in the
   synthesis log (`report_utilization` → DSP48E1 count) instead of trusting the tool.
2. `mac_array.v` — `P` parallel MACs + adder tree (P=16 first), registered inputs and outputs.
3. `requant.v` — shift, round, saturate to the next layer's activation width. Test with the nasty values:
   max/min int32, exact .5 ties, saturation edges.
4. `weight_bram.v` — weights in BRAM, one row per cycle, plus a `$readmemh` init path.
   **Watch the classic trap: a wrong `$readmemh` path silently yields an all-zero ROM.** Grep the synthesis
   log for `$readmem data file ... is read successfully` on every build.
5. `relu.v`, `argmax.v` (first-index-wins on ties, matching NumPy), `pool.v`.
6. `fsm` — layer sequencer: address generation, `valid` gating (accumulating garbage is the #1 silent bug),
   done/busy handshake.
Milestone: a layer-level testbench that runs layer 1 of the network end-to-end and matches the golden
activation dump byte-for-byte.

## Phase 4 — v1 accelerator: MLP on the board, end-to-end (3–5 weeks)

Goal: **a hand-drawn digit classified on real hardware.** Do not attempt convolution yet. Reduce input to
28x28 (784 bytes) if it shortens this phase; the point is the full loop.
- `npu_top.v`: weight BRAMs + MAC array + layer FSM + argmax, MMIO-style registers
  (`control`, `status`, `result`, `write-data`, `write-addr`).
- `host_if.v`: UART framer — `0xA5 | len | payload | checksum`, DMA-ish pixel streaming into `img_buffer`.
- Integration choice: either bare RTL host-IF FSM (simplest, recommended), or **reuse your R32 RISC-V
  core** as the control processor with the NPU as an MMIO peripheral at e.g. `0x4000_0000` — you already have
  that pattern working on this board, and it makes the demo firmware trivial.
- Outputs: prediction on LEDs (`LD3:0`) and the 7-seg display; raw logits over UART for debugging.
- Host: `host/draw_gui.py` — draw with the mouse, downsample to the model resolution, send, display result.
Done when: (a) sim matches golden for all vectors, and (b) on board, 20/20 digits you draw are classified
with the same result the host-side integer model predicts. **Log per-stage latency and utilisation in `docs/`.**

## Phase 5 — CNN engine at 50x50 (6–10 weeks) — the actual NPU

- **Line buffers**: 3-row circular line buffer so one new pixel per cycle feeds a 3x3 window (no im2col
  materialisation in memory). Read Kilts on pipelining and Meyer-Baese on 2-D FIR structures first.
- **Weight-stationary conv engine**: `Cout` filters mapped across PEs, weights loaded once per layer,
  activations streamed; the 9 taps of the 3x3 window are the natural P=9 inner dimension. See
  `sharatchandra-ts/systolic-TPU-CNN-accelerator` for a 9x4 SystolicConv/SystolicFC split (SystemVerilog).
- **Pooling** as a streaming 2x2 max on the way out of the conv stage; **FC layer** as an output-stationary
  tile loop.
- **Optional DSP48E1 tricks**: use the internal 48-bit accumulator (MACC) instead of an external adder tree,
  and the pre-adder to fold two window terms before the multiply — both cut LUT pressure significantly.
- **2x clocking**: put the compute array on a 200 MHz MMCM output if it closes (DSP48E1 goes far higher than
  the fabric); revisit only if you're throughput-starved.
Done when: 50x50 CNN classifies on board at the target baud, accuracy matches the integer golden model
within rounding, and timing is closed (positive WNS) at the chosen clock.

## Phase 6 — Demo & data domain (2 weeks)

- **Drawing app** (Tkinter/PIL): 50x50 canvas, mouse strokes, same normalisation/downsampling as training,
  live prediction, "save sample + label" button. Collect ~500 of your own drawings.
- **Retrain** on MNIST-upscaled + QuickDraw + your own samples; re-quantise; re-export. This is where the
  accuracy for *your* drawings comes from.
- **Display upgrade (optional, high demo value)**: 12-bit VGA out showing the 50x50 image beside the
  prediction — Basys3 has VGA, and it makes the project obviously real.
- Webcam path (like `adithyarg/MLP-Accelerator-for-MNIST-on-Basys3-FPGA` does) if you want hands-free demo.

## Phase 7 — Stretch goals

- Per-channel scales + mixed precision (4-bit weights, 8-bit activations) for a bigger model.
- Store a test set in the 4 MB QSPI flash (10,000 MNIST images = 7.84 MB, so ~5,000 fit) to benchmark
  THROUGHPUT without the UART in the loop.
- BNN variant (1-bit weights, XNOR + popcount in LUTs instead of DSPs) — a genuinely different datapath and
  a great comparison table for your write-up.
- Compare against **hls4ml** on the same network — a defensible "hand-written RTL vs HLS" analysis.
- Port to Arty A7-100T (2.7x BRAM, 240 DSP) — same RTL, one line of TCL changes.

---

## Reference designs to read (in this order)

| Project | Why it matters |
|---|---|
| `adithyarg/MLP-Accelerator-for-MNIST-on-Basys3-FPGA` | **Closest match to your target.** Basys3, XC7A35T, 784-64-32-10 MLP, Q4.12/Q8.8 fixed point, UART at 115200, webcam host, 94% MNIST, ~2.1 ms, Vivado 2024.2 + full TCL build, host protocol documented. Read the `report.md` and `training/quantize.py` first. |
| `haydenthai/FPGA-Neural-Network-Inferencer` | Same board but with **PicoRV32 as host** + MMIO accelerator + 7-seg + flash boot. The template for the soft-core-host architecture (near-identical to what your R32 core can do). |
| `sharatchandra-ts/systolic-TPU-CNN-accelerator` | SystemVerilog **CNN**: weight-stationary 9x4 systolic conv array, im2col address generator, skew unit, output-stationary FC with tiling, MaxPool, Argmax. The Phase 5 template. |
| `Xilinx/finn` + `Xilinx/brevitas` docs | Vocabulary of QNN dataflow, plus a QAT library you can actually use for Phase 1 even if you hand-write the RTL. |
| `fastmachinelearning/hls4ml` | Quantise→emit-hardware reference and a comparison baseline. |
| Google Quick, Draw! dataset | Free 28x28 line-drawing data at 50M scale — the antidote to MNIST domain shift. |

---

## Pitfalls that will cost you days

- **`$readmemh` paths are CWD-relative** and a bad path is silent (all-zero ROM). Grep the synthesis log for
  `read successfully` on every build; pass an absolute path via a parameter.
- **Accumulating on invalid beats**: gate accumulation with `valid` or you get plausible-but-wrong numbers.
- **Rounding mismatch between Python and Verilog** (banker's vs half-away-from-zero, floor vs truncate on
  negatives). Fix it in Phase 2 with nasty test vectors or you will chase a "quantisation accuracy drop"
  that is actually a rounding bug.
- **Adder-tree width**: int8 x int8 x 9 taps needs 16+4 = 20+ bits before saturation; size the accumulator
  from the worst case, not the average.
- **xsim rejects forward-declared identifiers** that Icarus and Vivado synthesis accept — simulate with
  Icarus/Verilator (you already do).
- **Uninitialised FSM/divider registers** simulate as `x` in Icarus and freeze downstream logic; give them
  explicit `initial` values.
- **Timing**: read the routed `report_timing_summary` (WNS/WHS) every iteration. If 100 MHz fails, find the
  critical path *before* reducing the clock — usually it's a wide mux or an unregistered BRAM output.
- **Only one process can hold a COM port** — a stale Python host leaves "Access is denied" and looks like
  broken hardware.
- **Don't build the CNN first.** v1 = MLP, on the board, classifying digits. Everything after that is
  optimization with a working reference in hand.

---

## Realistic schedule (part-time, your current skill level)

| Phase | Duration | Cumulative |
|---|---|---|
| Learning tiers 1–4 (in parallel with Phase 0–1) | 8–10 weeks | 10 wk |
| 0 Environment/loop | 1 wk | 1 wk |
| 1 Golden model + quantiser | 2 wk | 3 wk |
| 2 Integer simulator | 1 wk | 4 wk |
| 3 RTL blocks + cocotb | 3 wk | 7 wk |
| 4 MLP accelerator on board (v1 demo) | 4 wk | 11 wk |
| 5 CNN engine at 50x50 | 8 wk | 19 wk |
| 6 Demo, own-data retrain, VGA | 2 wk | 21 wk |

~5 months part-time to a CNN NPU on a Basys3 classifying your own hand-drawn digits at ~40 inf/s
(link-limited). A respectable, publishable/write-up-able project — and everything transfers to Arty A7-100T,
Zynq, or (via the same RTL discipline) an ASIC flow.
