function [ img ] = addContourToImg( img, mask, color )
%ADDCONTOURTOIMG Adds the contour of the specified mask to the specified
%img, using color as the line color.
%   img: the image to be added the contour to (RGB image uint8)
%   mask: the binary mask that contains the mask of the region of interest
%   color: the color of the line in RGB format [0..255]

perim = bwperim(mask);

R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);

R(perim) = color(1);
G(perim) = color(2);
B(perim) = color(3);

img = cat(3, R, G, B);

end

