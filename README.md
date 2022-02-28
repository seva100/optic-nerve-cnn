## Optic Disc and Cup Segmentation Methods with U-Net

*Note: the codebase is deprecated. It would require significant refactoring for newly released keras and tensorflow versions, however, due to the lack of time I am unable to do that continuously. Feel free to fork the repository to make any changes.*

This repository contains code in support of the paper: ["Optic Disc and Cup Segmentation Methods for Glaucoma Detection with Modification of U-Net Convolutional Neural Network"](https://arxiv.org/abs/1704.00979), available in several versions:
1. Sevastopolsky A., *Optic disc and cup segmentation methods for glaucoma detection with modification
of U-Net convolutional neural network*, Pattern Recognition and Image Analysis 27 (2017), no. 3, 618–624.
2. Sevastopolsky, Artem. *Optic Disc and Cup Segmentation Methods for Glaucoma Detection with Modification of U-Net Convolutional Neural Network.* arXiv preprint arXiv:1704.00979 (2017).

Highest versions tested on: Python 3.9.10; TensorFlow 2.8.0; numpy 1.22.2.

See *scripts* folder for notebooks for training with clarification of usage.   
HDF5 datasets can be recreated with *scripts/Organize datasets.ipynb* notebook or downloaded from [this url](https://drive.google.com/drive/folders/13g62bhqN1JHJ2fky2Xy5avLbZ2YLMdwB?usp=sharing).

*models_weights* folder contains pre-trained models.

Click the following links to watch content of notebooks in a handy way:
* [U-Net, OD on RIM-ONE v3 (fold 0).ipynb (**nbviewer**)](http://nbviewer.jupyter.org/github/seva100/optic-nerve-cnn/blob/master/scripts/U-Net%2C%20OD%20on%20RIM-ONE%20v3%20%28fold%200%29.ipynb)
* [U-Net, OD on DRIONS-DB (fold 0).ipynb (**nbviewer**)](http://nbviewer.jupyter.org/github/seva100/optic-nerve-cnn/blob/master/scripts/U-Net%2C%20OD%20on%20DRIONS-DB%20%28fold%200%29.ipynb)
* [U-Net, OD cup on RIM-ONE v3, cropped by OD (fold 0).ipynb (**nbviewer**)](http://nbviewer.jupyter.org/github/seva100/optic-nerve-cnn/blob/master/scripts/U-Net%2C%20OD%20cup%20on%20RIM-ONE%20v3%2C%20cropped%20by%20OD%20%28fold%200%29.ipynb)
* [U-Net, OD cup on DRISHTI-GS, cropped by OD (fold 0).ipynb (**nbviewer**)](http://nbviewer.jupyter.org/github/seva100/optic-nerve-cnn/blob/master/scripts/U-Net%2C%20OD%20cup%20on%20DRISHTI-GS%2C%20cropped%20by%20OD%20%28fold%200%29.ipynb)

The software is distributed under [MIT License](LICENSE), which requires that copyright notice and [this permission notice](LICENSE) shall be included in all copies or substantial portions of this software. Commercial use, distribution, modification and private use are allowed, but no warranty or support can be guaranteed.
