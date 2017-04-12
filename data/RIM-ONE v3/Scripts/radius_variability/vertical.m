function [ IR1, IR5 ] = vertical( xs, ys, centroid )
%VERTICAL Find the intersection points between the result of the
% segmentation and the vertical axes, corresponding to R1 and R5.


difer = abs(xs - centroid(1));
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

if isempty(inters) % no intersection point
    IR1 = centroid;
    IR5 = centroid;
else
    % Y coordinate is inverted in an image
    if inters(1,2) < inters(2,2)
        IR1 = inters(1,:);
        IR5 = inters(2,:);
    else
        IR1 = inters(2,:);
        IR5 = inters(1,:);
    end
end

end