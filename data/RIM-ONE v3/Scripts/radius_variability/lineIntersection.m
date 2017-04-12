function [ inters_point ] = lineIntersection( xi, yi, xe, ye, xs, ys, s )
%LINEINTERSECTION Find the intersection point between the result of the
% segmentation and a line defined by the points (xi, yi) and (xe, ye).

[x y] = bresenham(xi, yi, xe, ye);

aux = zeros(s(1), s(2));
for i=1:length(x),
    if (((x(i) > 0) && (y(i) > 0)) && ...
            ((x(i) < s(1)) && (y(i) < s(2))))
        aux(y(i), x(i)) = 1;
    end
end
map = bwdist(aux);

% Intersection point with the line defined by [x, y]
[value, ind_XY, ~] = intersect(floor([xs ys]), [x y], 'rows');
if isempty(value)
    clear value_map
    value_map = zeros(1, length(xs), 'double');
    for i = 1:length(xs),
        a = floor(ys(i));
        b = floor(xs(i));
        if a <= 0
            a = 1;
        end
        if b <= 0
            b = 1;
        end
        
        value_map(i) = map(a, b);
    end
    ind_XY = find(value_map == min(value_map));
end
                
inters_point = [mean(xs(ind_XY)) mean(ys(ind_XY))];

end

