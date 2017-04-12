function [ IR3, IR7 ] = horizontal( xs, ys, centroid )
%HORIZONTAL Find the intersection points between the result of the
% segmentation and the horizontal axes, corresponding to R3 and R7.

difer = abs(ys - centroid(2));
ind = find(difer == 0);
if (isempty(ind) || length(ind) < 2)
    ind = find(difer <= 1);
end

if length(ind) > 2
    [~, U, ~] = fcm([xs(ind) ys(ind)], 2, [NaN NaN NaN 0]);
    maxU = max(U);
    index1 = find(U(1,:) == maxU);
    index2 = find(U(2,:) == maxU);
    inters = [mean(xs(ind(index1))) mean(ys(ind(index1)))
        mean(xs(ind(index2))) mean(ys(ind(index2)))];
else
    inters = [xs(ind) ys(ind)];
end

if inters(1,1) < inters(2,1)
    IR7 = inters(1,:);
    IR3 = inters(2,:);
else
    IR7 = inters(2,:);
    IR3 = inters(1,:);
end

end

