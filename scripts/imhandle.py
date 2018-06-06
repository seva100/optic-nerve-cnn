# -*- coding: utf-8 -*-
"""
Created on Sun Sep 06 22:10:57 2015

@author: Artem S.
"""

import os
import glob
from math import sqrt
import numpy as np
import scipy as sp
from PIL import Image
import matplotlib.pyplot as plt
import matplotlib.cm as cm


class ImLibException(Exception):
    pass


def load_image(path):
    # returns an image of dtype int in range [0, 255]
    return np.asarray(Image.open(path))


def resize_image_to_square(img, side, pad_cval=0, dtype=np.float64):
    """Resizes img of shape (h, w, ch) or (h, w) to square of size (side, side, ch)
    or (side, side), respectively, while preserving aspect ratio.
    Image is being padded with pad_cval if needed."""

    if len(img.shape) == 2:
        h, w = img.shape
        if h == w:
            padded = img.copy()
        elif h > w:
            padded = np.full((h, h), pad_cval, dtype=dtype)
            l = int(h / 2 - w / 2)  # guaranteed to be non-negative
            r = l + w
            padded[:, l:r] = img.copy()
        else:
            padded = np.full((w, w), pad_cval, dtype=dtype)
            l = int(w / 2 - h / 2)  # guaranteed to be non-negative
            r = l + h
            padded[l:r, :] = img.copy()
    elif len(img.shape) == 3:
        h, w, ch = img.shape
        if h == w:
            padded = img.copy()
        elif h > w:
            padded = np.full((h, h, ch), pad_cval, dtype=dtype)
            l = int(h / 2 - w / 2)   # guaranteed to be non-negative
            r = l + w
            padded[:, l:r, :] = img.copy()
        else:
            padded = np.full((w, w, ch), pad_cval, dtype=dtype)
            l = int(w / 2 - h / 2)   # guaranteed to be non-negative
            r = l + h
            padded[l:r, :, :] = img.copy()
    else:
        raise ImLibException('only images of 2d and 3d shape are accepted')

    resized_img = sp.misc.imresize(padded, size=(side, side))
    return resized_img


def save_image(path, img):
    if img.max() <= 1.5:
        tmp = np.asarray(img * 255.0, dtype=np.uint8)
    else:
        tmp = np.asarray(img, dtype=np.uint8)
    Image.fromarray(tmp).save(path)


def show_image(img, fig_size=(10, 10)):
    plt.figure(figsize=fig_size)
    plt.imshow(img, cmap=cm.Greys_r)


def rmse(img, cleaned_img):
    return sqrt(np.mean((img - cleaned_img) ** 2))  
    # runs almost 2x times faster than sklearn.metrics.mean_square_error


def normalize_image(img):
    if len(img.shape) == 3 and img.shape[2] > 1:
        # multi-channel image
        new_img = img.copy()
        for i in range(img.shape[2]):
            new_img[:, :, i] -= new_img[:, :, i].min()
            new_img_max = new_img[:, :, i].max()
            if not np.isclose(new_img_max, 0):
                new_img[:, :, i] /= new_img_max
    else:
        # 2D (e.g. grayscale) or single-channel
        new_img = img.copy()
        new_img -= new_img.min()
        new_img_max = new_img.max()
        if not np.isclose(new_img_max, 0):
            new_img /= new_img_max
    return new_img


def load_set(folder, shuffle=False):
    img_list = sorted(glob.glob(os.path.join(folder, '*.png')) + \
                      glob.glob(os.path.join(folder, '*.jpg')) + \
                      glob.glob(os.path.join(folder, '*.jpeg')))
    if shuffle:
        np.random.shuffle(img_list)
    data = []
    filenames = []
    for img_fn in img_list:
        img = load_image(img_fn)
        data.append(img)
        filenames.append(img_fn)
    return data, filenames


def image_names_in_folder(folder):
    return sorted(glob.glob(os.path.join(folder, extension))
                  for extension in ('*.jpg', '*.jpeg', '*.JPG', '*.JPEG', '*.png', '*.bmp', '*.ppm'))


def rgb_to_grayscale(rgb_img):
    gs_img = 0.299 * rgb_img[:, :, 0] + 0.587 * rgb_img[:, :, 1] + 0.114 * rgb_img[:, :, 2]
    return gs_img


def pxl_distr(img):
    plt.hist(img.ravel(), bins=100)


def plot_subfigures(imgs, title=None, fig_size=None, contrast_normalize=False):
    if isinstance(imgs, list):
        imgs = np.array(imgs)
    if len(imgs.shape) == 4 and imgs.shape[0] == 1:
        imgs = imgs.reshape((imgs.shape[1], imgs.shape[2], imgs.shape[3]))
    if len(imgs.shape) == 2:
        # One picture
        if title is not None:
            plt.title(title)
        show_image(imgs)
    
    elif len(imgs.shape) == 3:
        # Multiple pictures in one row
        if fig_size is None:
            fig, axes = plt.subplots(nrows=1, ncols=imgs.shape[0])
                                     #figsize=(20, 20))
        else:
            fig, axes = plt.subplots(nrows=1, ncols=imgs.shape[0],
                                     figsize=fig_size)
        plt.gray()
        if title is not None:
            fig.suptitle(title, fontsize=12)
        for i in xrange(imgs.shape[0]):
            axes[i].axis('off')
            axes[i].set_xticks([])
            axes[i].set_yticks([])
            if contrast_normalize:
                axes[i].imshow(imgs[i])
            else:
                # Normalizing contrast for each image
                vmin, vmax = imgs[i].min(), imgs[i].max()
                axes[i].imshow(imgs[i], vmin=vmin, vmax=vmax)
            
    elif len(imgs.shape) == 4:
        # Multiple pictures in a few rows
        if fig_size is None:
            fig, axes = plt.subplots(nrows=imgs.shape[0], ncols=imgs.shape[1])
                                     #figsize=(20, 20))
        else:
            fig, axes = plt.subplots(nrows=imgs.shape[0], ncols=imgs.shape[1],
                                     figsize=fig_size)
        plt.gray()
        if title is not None:
            fig.suptitle(title, fontsize=12)
        for i in xrange(imgs.shape[0]):
            for j in xrange(imgs.shape[1]):
                axes[i][j].axis('off') 
                axes[i][j].set_xticks([])
                axes[i][j].set_yticks([])
                if contrast_normalize:
                    axes[i][j].imshow(imgs[i][j])
                else:
                    # Normalizing contrast for each image
                    vmin, vmax = imgs[i][j].min(), imgs[i][j].max()
                    axes[i][j].imshow(imgs[i][j], vmin=vmin, vmax=vmax)
    else:
        raise ImLibException("imgs array contains 3D set of images or deeper")
