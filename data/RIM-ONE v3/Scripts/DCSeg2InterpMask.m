function [ img, mask, center, puntos ] = DCSeg2InterpMask( imageFilename, dcSegFilename )
%CREATEMASKFROMELLIPSESEGMENT Create an image mask from a segmentation
%carried out with an ellipse and the 16 radii method for a particular image

% Mask interpolation from coordinates file
img = imread(imageFilename);
fid = fopen(dcSegFilename);
e = textscan(fid, '%s %s', 1);
e = textscan(fid, '%s', 1, 'Delimiter', '\n');
center = textscan(fid, '%d %d', 1, 'Delimiter', '\n');
puntos = textscan(fid, '%f %f', 16, 'Delimiter', '\n');

X1=interp([puntos{1}; puntos{1}(1)], 50);
Y1=interp([puntos{2}; puntos{2}(1)], 50);

[~, ~, ~, mask, ~, ~] = roifill(zeros(size(img(:,:,1))), X1(1:16*50), Y1(1:16*50));
mask = double(mask);

fclose(fid);

end

