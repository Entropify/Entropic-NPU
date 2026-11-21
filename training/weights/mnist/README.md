# MNIST digit weights

All models accept 50×50 uint8 grayscale input (white ink on black) and classify digits 0–9. Output index is the digit value. Folder names explicitly give the number of convolution layers; G2 and G3 are experiment names, not layer counts.

| Folder | Conv layers | Channels | Head | Weight bytes | Clean accuracy | Distorted accuracy |
|---|---:|---|---|---:|---:|---:|
| `2-conv/beta-fc/` | **2** | 8 → 16 | Flattened FC, 1936 → 10 | 20,584 | 97.37% | 91.06% |
| `3-conv/G2-gap/` | **3** | 8 → 16 → 32 | GAP + 32 → 10 | 6,152 | 98.01% | 92.41% |
| `4-conv/G3-gap/` | **4** | 8 → 16 → 32 → 32 | GAP + 32 → 10 | 15,368 | 99.25% | 96.59% |

**`2-conv/beta-fc/` is the original two-convolution MNIST model.** It has a flattened fully connected head, not GAP. All convs are valid 3×3. Max-pooling follows the first two convs; the added convs in G2/G3 have no pooling. GAP variants use integer global sums with the averaging factor folded into classifier weights.

Each model folder contains `int_model.npz` (int8 `L{i}_W`, int32 `L{i}_b`) and `model_meta.json` (layer shapes, quantization parameters, evaluation results and training history). Always load a checkpoint with its own metadata. Weight byte counts exclude biases/container overhead.

Saved integer evaluation results above use 10,000 clean MNIST test images resized from 28×28 to 50×50 with the training pipeline's bilinear resize, and a fixed 10,000-image synthetically distorted test set. One training seed; not fresh hardware benchmarks. Do not use the Chinese-specific crop/contrast preprocessing for these results.

These are checkpoint exports, not FPGA memory-initialization images. RTL compatibility has not been verified. G2/G3 require unpooled conv and `sumfc` support; beta requires the flattened `fc` head.
