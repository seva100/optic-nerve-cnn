function [ radii ] = getRadiiDist( centroid, xs, ys, perim )
%GETRADIIDIST This function is part of the variability measurement
%procedure of the RIM-ONE database
%Input parameters:
%   centroid: the centroid of the logical mask that is going to be measured
%   xs, ys: the (x,y) points of the perimter of the logical mask

% Steps 2 and 3: Consider the same eight directional axes. These axes cover 
% regularly the most important zones of the ONH image.

% Find the intersection with R1 and R5
[IR1, IR5] = vertical(xs, ys, centroid);

% Find the intersection with R3 and R7
[IR3, IR7] = horizontal(xs, ys, centroid);

% Find the intersection with R2, R4, R6 and R8
[IR2, IR4, IR6, IR8] = diagonal(xs, ys, centroid, size(perim));

% Step 4: Calculate the distances between the reference point (centroid) 
% and these intersection points.
radii = zeros(1, 8, 'double');
radii(1) = euDist(centroid, IR1);
radii(2) = euDist(centroid, IR2);
radii(3) = euDist(centroid, IR3);
radii(4) = euDist(centroid, IR4);
radii(5) = euDist(centroid, IR5);
radii(6) = euDist(centroid, IR6);
radii(7) = euDist(centroid, IR7);
radii(8) = euDist(centroid, IR8);


end

