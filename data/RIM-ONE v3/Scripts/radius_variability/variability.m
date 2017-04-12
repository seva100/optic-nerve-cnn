function [ VP ] = variability( centroid, AR, segIm )
%VARIABILITY Variability measurement procedure to evaluate optic nerve head
% segmentation algorithms

%   This procedure is described in detail in the following paper:
%       F. Fumero, S. Alayon, J.L. Sanchez, J. Sigut, M.
%       Gonzalez-Hernandez, "RIM-ONE: An Open Retinal Image Database for 
%       Optic Nerve Evaluation", 2011.
%   For more information, please visit RIM-ONE website:
%       http://rimone.isaatc.ull.es
%
%   Input parameters:
%      centroid: centroid of the gold standard.
%      AR: vector with the average radii, i.e. [AR1, AR2,..., AR8].
%      segIm: binary image with the result of the segmentation of the 
%             image of the study.
%
%   Output parameters:
%      VP: vector containing the variability percentage (VP) for each 
%          direction between the segmentation result and the gold standard.

perim = bwperim(segIm);
[ys, xs] = find(perim > 0);

[ radii ] = getRadiiDist( centroid, xs, ys, perim );

% Step 5: calculate the variability percentage (VP) for each direction 
% between the segmentation result and the gold standard
VP = zeros(1, 8, 'double');
for i = 1:8
    VP(i) = (abs(radii(i) - AR(i)) / AR(i)) * 100;
end

end