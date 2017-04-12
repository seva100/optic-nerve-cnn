function [ D ] = euDist( p1, p2 )
%EUDIST Euclidean distance
%   Computes the Euclidean distance between two points in R2
%   Input parameters:
%       p1: a point represented by X and Y coordinates
%       p2: a point represented by X and Y coordinates

D = sqrt( (p2(1) - p1(1))^2 + (p2(2) - p1(2))^2 );

end

