# MNIST digit weights

G3 integer-quantized CNN for handwritten digits 0–9. Input is 50×50 uint8 grayscale, white ink on black. Output index is the digit value.

`G3/int_model.npz` contains int8 weights (`L{i}_W`) and int32 biases (`L{i}_b`). `G3/model_meta.json` contains layer shapes, per-layer quantization parameters, pooling flags, training history and evaluation results. Weight tensor shapes match the Chinese-numeral G3 checkpoint, but quantization parameters and label meanings must be loaded with each model.

Architecture: valid 3×3 conv 1→8, max pool; valid 3×3 conv 8→16, max pool; valid 3×3 conv 16→32; valid 3×3 conv 32→32; global sum-pool and 32→10 classifier. The global-average factor is folded into the head weights.

- Weight storage: 15,368 bytes, excluding biases and container overhead.
- Recorded integer accuracy: **99.25%** on the 10,000-image MNIST test set, resized from 28×28 to 50×50 with the training pipeline's bilinear resize.
- Recorded integer accuracy: **96.59%** on the fixed 10,000-image synthetically distorted MNIST test set.
- Integer and QAT predictions agreed on 100% of both test sets. One training seed; these are saved evaluation results, not a fresh hardware benchmark.

This is a checkpoint export, not a hardware memory-initialization image. RTL compatibility has not been verified. It requires support for the descriptor semantics, including unpooled conv layers and the `sumfc` head. Do not apply the Chinese-specific bounding-box/contrast preprocessing to reproduce the MNIST evaluation numbers.
