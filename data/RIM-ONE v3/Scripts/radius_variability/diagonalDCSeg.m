function [ IR12, IR23, IR34, IR45, IR56, IR67, IR78, IR81 ] = diagonalDCSeg( xs, ys, centroid, s )
%DIAGONAL Find the intersection points between the result of the
% segmentation and the diagonal axes located in the midpoints of the 8
% original radii of RIM-ONE

xi = centroid(1);
yi = centroid(2);

% +67.5º (R1-R2)
xe = xi + yi;
ye = -yi;
IR12 = lineIntersection(xi, yi, xe, ye, xs, ys, s);

% +22.5º (R2-R3)
xe = xi + 2*yi;
ye = 1;
IR23 = lineIntersection(xi, yi, xe, ye, xs, ys, s);

% +337.5º (R3-R4)
xe = xi + 2*yi;
ye = yi + yi;
IR34 = lineIntersection(xi, yi, xe, ye, xs, ys, s);

% +292.5º (R4-R5)
xe = xi + yi;
ye = yi + 2*yi;
IR45 = lineIntersection(xi, yi, xe, ye, xs, ys, s);

% +247.5º (R5-R6)
xe = xi - yi;
ye = yi + 2*yi;
IR56 = lineIntersection(xi, yi, xe, ye, xs, ys, s);

% +202.5º (R6-R7)
xe = xi - 2*yi;
ye = yi + yi;
IR67 = lineIntersection(xi, yi, xe, ye, xs, ys, s);

% +157.5º (R7-R8)
xe = xi - 2*yi;
ye = 1;
IR78 = lineIntersection(xi, yi, xe, ye, xs, ys, s);

% +112.5º (R8-R1)
xe = xi - yi;
ye = -yi;
IR81 = lineIntersection(xi, yi, xe, ye, xs, ys, s);

end