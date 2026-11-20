# Chinese numeral weights

Integer-quantized G2 and G3 CNN checkpoints for 50×50 uint8 grayscale input (white ink on black). Output indices 0–9 represent 零 一 二 三 四 五 六 七 八 九.

Each directory contains `int_model.npz` (arrays `L{i}_W` and `L{i}_b`) and `model_meta.json` (layer shapes, quantization shifts, pooling flags and evaluation results). These are checkpoint exports, not FPGA-ready memory initialization files. The engine must support their layer descriptors, including convolutions without pooling and a `sumfc` head; compatibility with this repository's RTL has not been verified.

| Model | int8 weight bytes (excluding biases/container overhead) | Clean accuracy | Distorted accuracy |
|---|---:|---:|---:|
| G2 | 6,152 | 98.00% | 85.25% |
| G3 | 15,368 | 98.70% | 93.85% |

Evaluation: 2,000 Chinese MNIST images from held-out writers 81–100, 200 examples per class. Writers 1–70 trained the models; writers 71–80 supplied validation. Single training seed. Distorted evaluation uses fixed synthetic augmentation, not handwritten app input. Integer and QAT predictions agreed on all clean and distorted test examples.

Dataset source: https://github.com/duriantaco/Chinese-MNIST (Chinese MNIST, restricted to its first ten character codes). Input preparation crops the ink bounding box, scales its longest side to 36 pixels, centers it on a 50×50 canvas and stretches contrast. These exports require that Chinese-specific preparation, not an unmodified 28×28 MNIST preprocessing path.
