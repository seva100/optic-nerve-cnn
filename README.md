## Optic Disc and Cup Segmentation Methods with U-Net

This repository contains code in support of the paper: ["Optic Disc and Cup Segmentation Methods for Glaucoma Detection with Modification of U-Net Convolutional Neural Network"](https://arxiv.org/abs/1704.00979):

*Sevastopolsky, Artem. "Optic Disc and Cup Segmentation Methods for Glaucoma Detection with Modification of U-Net Convolutional Neural Network." arXiv preprint arXiv:1704.00979 (2017).*

*(accepted for publication in "Pattern Recognition and Image Analysis: Advances in Mathematical Theory and Applications" journal, ISSN 1054-6618)*

Built with Python 2.7 and Keras.

See *scripts* folder for notebooks for training with clarification of usage. HDF5 datasets should be recreated with *scripts/Organize datasets.ipynb* notebook. *models_weights* folder contains pre-trained models.

Click the following links to watch content of notebooks in a handy way:
* [U-Net, OD on RIM-ONE v3 (fold 0).ipynb (**nbviewer**)](http://nbviewer.jupyter.org/github/seva100/optic-nerve-cnn/blob/master/scripts/U-Net%2C%20OD%20on%20RIM-ONE%20v3%20%28fold%200%29.ipynb)
* [U-Net, OD on DRIONS-DB (fold 0).ipynb (**nbviewer**)](http://nbviewer.jupyter.org/github/seva100/optic-nerve-cnn/blob/master/scripts/U-Net%2C%20OD%20on%20DRIONS-DB%20%28fold%200%29.ipynb)
* [U-Net, OD cup on RIM-ONE v3, cropped by OD (fold 0).ipynb (**nbviewer**)](http://nbviewer.jupyter.org/github/seva100/optic-nerve-cnn/blob/master/scripts/U-Net%2C%20OD%20cup%20on%20RIM-ONE%20v3%2C%20cropped%20by%20OD%20%28fold%200%29.ipynb)
* [U-Net, OD cup on DRISHTI-GS, cropped by OD (fold 0).ipynb (**nbviewer**)](http://nbviewer.jupyter.org/github/seva100/optic-nerve-cnn/blob/master/scripts/U-Net%2C%20OD%20cup%20on%20DRISHTI-GS%2C%20cropped%20by%20OD%20%28fold%200%29.ipynb)
