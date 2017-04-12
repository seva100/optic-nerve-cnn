function [ maxHorzLength, maxHorzCol ] = getMaxHorizontalLength( mask )
%GETMAXHORIZONTALLENGTH Returns the maximum horizontal length of the region
[row, col] = find(mask);

unRow = unique(row);
maxHorzLength = 0;
maxHorzCol = 0;
for i = 1:length(unRow)
    indRow = row == unRow(i);
    cols = col(indRow);
    hLength = max(cols) - min(cols);
    if hLength > maxHorzLength
        maxHorzLength = hLength;
        maxHorzCol = unRow(i);
    end
end

end

