function [ IR2, IR4, IR6, IR8 ] = diagonal( xs, ys, centroid, s )
%DIAGONAL Find the intersection points between the result of the
% segmentation and the diagonal axes, corresponding to R2, R4, R6 and R8.

% +45º (R2)
xi = centroid(1);
xe = centroid(1) + centroid(2);
yi = centroid(2);
ye = 1;

IR2 = lineIntersection(xi, yi, xe, ye, xs, ys, s);

% +315º (R4)
xi = centroid(1);
xe = centroid(1) + centroid(2);
yi = centroid(2);
ye = centroid(2) + centroid(2);

IR4 = lineIntersection(xi, yi, xe, ye, xs, ys, s);

% +225º (R6)
xi = centroid(1);
xe = centroid(1) - (s(2) - centroid(2));
yi = centroid(2);
ye = s(2);

IR6 = lineIntersection(xi, yi, xe, ye, xs, ys, s);

% +135º (R8)
xi = centroid(1);
xe = centroid(1) - centroid(2);
yi = centroid(2);
ye = 1;

IR8 = lineIntersection(xi, yi, xe, ye, xs, ys, s);

end