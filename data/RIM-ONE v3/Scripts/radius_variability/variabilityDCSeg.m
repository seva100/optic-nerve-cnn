function [ VP ] = variabilityDCSeg( refIm, segIm, eyeSide )
%VARIABILITY Variability measurement procedure to evaluate optic nerve head
% segmentation algorithms

%   This procedure is used to evaluate the results of the third version of RIM-ONE.
%   For more information, please visit our website:
%       http://medimrg.webs.ull.es
%
%   Input parameters:
%      refIm: binary image with the reference segmentation of the image of
%             the study (gold standard or expert segmentation).
%      segIm: binary image with the result of the segmentation of the 
%             image of the study.
%      eyeSide: the side of the eye being evaluated.
%
%   Output parameters:
%      VP: vector containing the variability percentage (VP) for each 
%          direction between the segmentation result and the reference
%          segmentation. VP(1) will be Superior zone, VP(2) Superior-Nasal,
%          VP(3) Nasal, and so on.

centroid = regionprops(refIm, 'centroid');
centroid = centroid(1).Centroid;

if segIm(round(centroid(2)), round(centroid(1))) == false
    VP = zeros(1, 8) + NaN;
    return;
end

refPerim = bwperim(refIm);
[yref, xref] = find(refPerim > 0);
[ refRadii ] = getRadiiDist( centroid, xref, yref, refPerim );


perim = bwperim(segIm);
[ys, xs] = find(perim > 0);

[ radii ] = getRadiiDist( centroid, xs, ys, perim );

% Step 5: calculate the variability percentage (VP) for each direction 
% between the segmentation result and the gold standard
VP = zeros(1, 8, 'double');
for i = 1:8
    VP(i) = (abs(radii(i) - refRadii(i)) / refRadii(i)) * 100;
end

% Swap left and right radii so the temporal zone of a left image matches
% the same zone of a right image
if strcmpi(eyeSide, 'L')
    VP = VP([1 8 7 6 5 4 3 2]);
end

end