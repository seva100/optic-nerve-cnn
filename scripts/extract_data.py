import os
import numpy as np
import pandas as pd
import cv2
import imhandle as imh

HEALTHY = 0
GLAUCOMA_OR_SUSPECT = 1


def extract_DRIONS_DB(db_folder, expert=1):
    """
    Full images with polygonal optic disc segmentation from 2 experts.
    400 x 600 original, 560 x 560 after post-processing.
    Images have unwanted text at the left, so it needs to be dropped out.

    Accepted values for `expert`: 1, 2.

    Required schema:
    db_folder/
       images/
           image_{:03}.jpg
       experts_annotation/
           anotExpert1_{:03}.txt
           anotExpert2_{:03}.txt
    """
    orig_resolution = (400, 600)
    left_cut_thr = 40
    result_resolution = (orig_resolution[1] - left_cut_thr, orig_resolution[1] - left_cut_thr)

    X, filenames = imh.load_set(os.path.join(db_folder, 'images'))

    file_codes = [fn[-7:-4] for fn in filenames]
    Y = []
    for i, code in enumerate(file_codes):
        anot_filename = os.path.join(db_folder, 'experts_annotation', 'anotExpert{}_{}.txt'.format(expert, code))
        with open(anot_filename) as anot_fin:
            coords = anot_fin.readlines()
        coords = map(lambda s: map(lambda x: int(round(float(x))), s.split(' , ')),
                     coords)
        coords = np.array(coords)
        segm_img = np.zeros(orig_resolution, dtype=np.uint8)
        cv2.fillPoly(segm_img, coords.reshape((1,) + coords.shape), color=1)
        Y.append(segm_img)

    for i in xrange(len(X)):
        side = result_resolution[0]
        X[i] = imh.resize_image_to_square(X[i][:, left_cut_thr:], side, pad_cval=0)
        Y[i] = imh.resize_image_to_square(Y[i][:, left_cut_thr:], side, pad_cval=0)
        Y[i] = Y[i].reshape(Y[i].shape + (1,))

    return X, Y, file_codes


def get_resolution_DRIONS_DB():
    """Returns DRIONS_DB resolution after post-processing."""
    return (560, 560)


def extract_RIM_ONE_v2(db_folder):
    """
    Cropped (to optic disc region) images with polygonal optic disc segmentation.
    380 x 394 original, 394 x 394 after post-processing.

    Required schema:
    db_folder/
       Normal/
           im{:03}.jpg   (number from 0 to 255)
           im{:03}_gs.txt
       Glaucoma and glaucoma suspicious/
           im{:03}.jpg    (number from 256 to 455)
           im{:03}_gs.txt
    """

    orig_resolution = (380, 394)
    result_resolution = (394, 394)

    X_all, Y_all, filecodes_all, is_ill = [], [], [], []
    for pic_type in ('Normal', 'Glaucoma and glaucoma suspicious'):
        X, filenames = imh.load_set(os.path.join(db_folder, pic_type))
        file_codes = [fn[-7:-4] for fn in filenames]
        Y = []
        for i, code in enumerate(file_codes):
            anot_filename = os.path.join(db_folder, pic_type, 'Im{}-gs.txt'.format(code))
            with open(anot_filename) as anot_fin:
                lines = anot_fin.readlines()
            
            '''
            # polygonal segmentation
            coords = lines[1:lines.index('Ellipse parameters\r\n')]
            coords = np.array(map(int, coords))
            if coords.size % 2 != 0:
                raise imh.ImLibException('n_coords % 2 != 0')
            coords = coords.reshape((coords.size / 2, 2))
            coords = coords[1:]    # optic disc center point is included in annotation for some reason
            segm_img = np.zeros(orig_resolution, dtype=np.uint8)
            cv2.fillPoly(segm_img, coords.reshape((1,) + coords.shape), color=1)
            '''
            '''
            # ellipse segmentation
            coords = lines[lines.index('Ellipse parameters\r\n') + 1:]
            coords = map(int, coords)
            i0, j0, a, b, angle = coords
            a /= 2
            b /= 2
            segm_img = np.zeros(orig_resolution, dtype=np.uint8)
            cv2.ellipse(segm_img, (i0, j0), (a, b), angle, 0, 360, color=1, thickness=-1)
            '''
            # acquiring segmentation from pre-computed image
            segm_img = imh.load_image(os.path.join(db_folder, pic_type + ' segmentation', 'Im{}-gs_mask.jpg'.format(code)))
            
            Y.append(segm_img)
            is_ill.append(HEALTHY if pic_type == 'Normal' else GLAUCOMA_OR_SUSPECT)

        for i in xrange(len(X)):
            side = result_resolution[0]
            X[i] = imh.resize_image_to_square(X[i], side, pad_cval=0)
            Y[i] = imh.resize_image_to_square(Y[i], side, pad_cval=0)
            Y[i] = Y[i].reshape(Y[i].shape + (1,))

        X_all.extend(X)
        Y_all.extend(Y)
        filecodes_all.extend(file_codes)
    return X_all, Y_all, filecodes_all, is_ill


def get_resolution_RIM_ONE_v2():
    """Returns RIM_ONE_v2 resolution after post-processing."""
    return (394, 394)


def extract_RIM_ONE_v3(db_folder, expert='avg', return_disc=True, return_cup=True):
    """
    Cropped (to optic disc region, and a little more by vertical axis) images
    with polygonal optic disc segmentation. 1424 x 2144 original, 1424 x 1424 after post-processing.
    Images are two-channel (stereo) --- caught from 2 angles.
    But segmentation is given for only one view (see L/R letter in file name for clarification).
    So only one view of two is chosen.

    Accepted values for `expert`: 1, 2, 'avg'.

    Required schema:
    db_folder/
        Healthy/
            Stereo Images/
                N-{}-[L,R].jpg    (number is without leading zeros, from 1 to 92)
                                  (image cannot be used as is. it is two-part image, divided by vertical border)
            Expert1_masks/
                N-{}-[L,R]-Cup-exp1.png    (4 files for one image number and L/R characteristic)
                N-{}-[L,R]-Cup-exp1.txt
                N-{}-[L,R]-Disc-exp1.png
                N-{}-[L,R]-Disc-exp1.txt
            Expert2_masks/
                N-{}-[L,R]-Cup-exp2.png    (4 files for one image number and L/R characteristic)
                N-{}-[L,R]-Cup-exp2.txt
                N-{}-[L,R]-Disc-exp2.png
                N-{}-[L,R]-Disc-exp2.txt
            Average_masks/
                N-{}-[L,R]-Cup-Avg.png    (4 files for one image number and L/R characteristic)
                N-{}-[L,R]-Cup-Avg.txt
                N-{}-[L,R]-Disc-Avg.png
                N-{}-[L,R]-Disc-Avg.txt

        Glaucoma and suspects/
            (...)    (the same as for Healthy, but images start with G not N)
    """

    orig_resolution = (1424, 2144)
    result_resolution = (1424, 1424)

    if expert == 1:
        expert_folder = 'Expert1_masks'
        suffix = 'exp1'
    elif expert == 2:
        expert_folder = 'Expert2_masks'
        suffix = 'exp2'
    elif expert == 'avg':
        expert_folder = 'Average_masks'
        suffix = 'Avg'
    else:
        raise imh.ImLibException('value for "expert" argument not understood')

    X_all, disc_all, cup_all, file_codes_all, is_ill = [], [], [], [], []
    for pic_type in ('Healthy', 'Glaucoma and suspects'):
        X, file_names = imh.load_set(os.path.join(db_folder, pic_type, 'Stereo Images'))
        X_all.extend(X)
        rel_file_names = [os.path.split(fn)[-1] for fn in file_names]
        file_codes = [fn[:fn.rfind('.')] for fn in rel_file_names]
        file_codes_all.extend(file_codes)

        for fc in file_codes:
            if return_disc:
                disc_segmn = imh.load_image(os.path.join(db_folder, pic_type, expert_folder,
                                                           '{}-Disc-{}.png'.format(fc, suffix)))
                disc_all.append(disc_segmn)

            if return_cup:
                cup_segmn = imh.load_image(os.path.join(db_folder, pic_type, expert_folder,
                                                          '{}-Cup-{}.png'.format(fc, suffix)))
                cup_all.append(cup_segmn)

            is_ill.append(HEALTHY if pic_type == 'Healthy' else GLAUCOMA_OR_SUSPECT)

    for i in xrange(len(X_all)):
        side = result_resolution[0]
        if file_codes_all[i][-1] == 'L':
            X_all[i] = X_all[i][:, :orig_resolution[1] / 2]
        elif file_codes_all[i][-1] == 'R':
            X_all[i] = X_all[i][:, orig_resolution[1] / 2:]
        if return_disc:
            disc_all[i] = disc_all[i][:, :orig_resolution[1] / 2]
        if return_cup:
            cup_all[i] = cup_all[i][:, :orig_resolution[1] / 2]
        else:
            raise imh.ImLibException('image {} has no L/R characteristic'.format(file_codes_all[i]))

        X_all[i] = imh.resize_image_to_square(X_all[i], side, pad_cval=0)
        if return_disc:
            disc_all[i] = imh.resize_image_to_square(disc_all[i], side, pad_cval=0)
            disc_all[i] = disc_all[i].reshape(disc_all[i].shape + (1,))
        if return_cup:
            cup_all[i] = imh.resize_image_to_square(cup_all[i], side, pad_cval=0)
            cup_all[i] = cup_all[i].reshape(cup_all[i].shape + (1,))

    if return_disc:
        if return_cup:
            return X_all, disc_all, cup_all, file_codes_all, is_ill
        return X_all, disc_all, file_codes_all, is_ill
    if return_cup:
        return X_all, cup_all, file_codes_all, is_ill
    return X_all, file_codes_all, is_ill


def get_resolution_RIM_ONE_v3():
    """Returns RIM_ONE_v3 resolution after post-processing."""
    return (1424, 1424)


def extract_DRISHTI_GS_train(db_folder, return_disc=True, return_cup=True):
    """
    Full images with optic disc and optic cup segmentation.
    Average segmentation and "softmap" segmentation image are given.
    50 images of various resolution close to 2040 x 1740.
    Data set is split into training and test sets. Groundtruth is available for training set only.
    This function returns Training set only.
    
    Required schema:
    db_folder/
        Drishti-GS1_files/
            Training/
                Images/
                    drishtiGS_{:03}.png    # some numbers are omitted, like 001, 003, 004, ...
                GT/
                    drishtiGS_{:03}/
                        drishtiGS_{:03}_cdrValues.txt
                        AvgBoundary/
                            drishtiGS_{:03}_ODAvgBoundary.txt
                            drishtiGS_{:03}_CupAvgBoundary.txt
                            drishtiGS_{:03}_diskCenter.txt
                        SoftMap/
                            drishtiGS_{:03}_ODsegSoftmap.png
                            drishtiGS_{:03}_cupsegSoftmap.png
    """
    result_resolution = (2040, 2040)

    disc_all, cup_all, file_codes_all = [], [], []
    set_path = os.path.join(db_folder, 'Drishti-GS1_files', 'Training')
    images_path = os.path.join(set_path, 'Images')
    X_all, file_names = imh.load_set(images_path)
    rel_file_names = [os.path.split(fn)[-1] for fn in file_names]
    rel_file_names_wo_ext = [fn[:fn.rfind('.')] for fn in rel_file_names]
    file_codes = ['Training' + fn[fn.find('_'):] for fn in rel_file_names_wo_ext]
    file_codes_all.extend(file_codes)

    for fn in rel_file_names_wo_ext:
        if return_disc:
            disc_segmn = imh.load_image(os.path.join(set_path, 'GT', fn,
                                                     'SoftMap', fn + '_ODsegSoftmap.png'))
            disc_all.append(disc_segmn)

        if return_cup:
            cup_segmn = imh.load_image(os.path.join(set_path, 'GT', fn,
                                                    'SoftMap', fn + '_cupsegSoftmap.png'))
            cup_all.append(cup_segmn)

    for i in xrange(len(X_all)):
        side = result_resolution[0]

        X_all[i] = imh.resize_image_to_square(X_all[i], side, pad_cval=0)
        if return_disc:
            disc_all[i] = imh.resize_image_to_square(disc_all[i], side, pad_cval=0)
            disc_all[i] = disc_all[i].reshape(disc_all[i].shape + (1,))
        if return_cup:
            cup_all[i] = imh.resize_image_to_square(cup_all[i], side, pad_cval=0)
            cup_all[i] = cup_all[i].reshape(cup_all[i].shape + (1,))

    if return_disc:
        if return_cup:
            return X_all, disc_all, cup_all, file_codes_all
        return X_all, disc_all, file_codes_all
    if return_cup:
        return X_all, cup_all, file_codes_all
    return X_all, file_codes_all


def extract_DRISHTI_GS_test(db_folder):
    """
    Full images with optic disc and optic cup segmentation.
    Average segmentation and "softmap" segmentation image are given.
    51 images of various resolution close to 2040 x 1740.
    Data set is split into training and test sets. Groundtruth is available for training set only.
    This function returns Test set only.
    
    Required schema:
    db_folder/
        Drishti-GS1_files/
            Test/
                Images/
                    drishtiGS_{:03}.png    # numbers overlap with train
    """
    result_resolution = (2040, 2040)
    
    set_path = os.path.join(db_folder, 'Drishti-GS1_files', 'Test')
    images_path = os.path.join(set_path, 'Images')
    X_all, file_names = imh.load_set(images_path)
    rel_file_names = [os.path.split(fn)[-1] for fn in file_names]
    rel_file_names_wo_ext = [fn[:fn.rfind('.')] for fn in rel_file_names]
    file_codes = ['Test' + fn[fn.find('_'):] for fn in rel_file_names_wo_ext]
    
    for i in xrange(len(X_all)):
        side = result_resolution[0]
        X_all[i] = imh.resize_image_to_square(X_all[i], side, pad_cval=0)
    
    return X_all, file_codes 


def get_resolution_DRISHTI_GS():
    """Returns DRISHTI-GS resolution after post-processing."""
    #return (2040, 1750)
    return (2040, 2040)


def extract_HRF(db_folder, expert=1):
    """
    Full images with primitive optic disc segmentation (as a circle).
    2336 x 3504 original, 3504 x 3504 after preprocessing.

    Accepted values for `expert`: 1, 2.

    Required schema:
    db_folder/
        Healthy/
            {:02}_h.jpg    (number from 01 to 15)
        Glaucomatous/
            {:02}_h.jpg    (number from 01 to 15)
        optic_disk_centers_expert_A.csv
        optic_disk_centers_expert_B.csv
    """

    orig_resolution = (2336, 3504)
    result_resolution = (3504, 3504)

    if expert == 1:
        expert_letter = 'A'
    elif expert == 2:
        expert_letter = 'B'
    anot_df = pd.read_csv(os.path.join(db_folder, 'optic_disk_centers_expert_{}.csv'.format(expert_letter)),
                          index_col=0)

    X_all, Y_all, file_codes_all, is_ill = [], [], [], []
    for pic_type in ('Healthy', 'Glaucomatous'):
        X, file_names = imh.load_set(os.path.join(db_folder, pic_type))
        X_all.extend(X)
        rel_file_names = [os.path.split(fn)[-1] for fn in file_names]
        file_codes = [fn[:fn.rfind('.')] for fn in rel_file_names]
        file_codes_all.extend(file_codes)

        for i in xrange(len(X)):
            record_str = file_codes[i]
            if expert == 2:
                record_str = record_str.replace('_', '')

            anot_record = anot_df.loc[record_str]
            od_center = (anot_record['Pap. Center x'], anot_record['Pap. Center y'])
            #od_center = (anot_record['vessel orig. x'], anot_record['vessel orig. y'])
            od_radius = anot_record['disk diameter'] / 2
            segmn_img = np.zeros(orig_resolution, dtype=np.uint8)
            cv2.circle(segmn_img, od_center, od_radius, color=1, thickness=-1)
            Y_all.append(segmn_img)
            is_ill.append(HEALTHY if pic_type == 'Healthy' else GLAUCOMA_OR_SUSPECT)

    for i in xrange(len(X_all)):
        side = result_resolution[0]
        X_all[i] = imh.resize_image_to_square(X_all[i], side, pad_cval=0)
        Y_all[i] = imh.resize_image_to_square(Y_all[i], side, pad_cval=0)
        Y_all[i] = Y_all[i].reshape(Y_all[i].shape + (1,))

    return X_all, Y_all, file_codes_all, is_ill


def get_resolution_HRF():
    """Returns RIM_ONE_v2 resolution after post-processing."""
    return (3504, 3504)

