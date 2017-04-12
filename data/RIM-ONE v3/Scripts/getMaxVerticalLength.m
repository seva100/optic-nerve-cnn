function [ maxVertLength, maxVertCol ] = getMaxVerticalLength( mask )
%GETMAXVERTICALRADIO Returns the maximum vertical length of the region
[row, col] = find(mask);

unCol = unique(col);
maxVertLength = 0;
maxVertCol = 0;
for i = 1:length(unCol)
    indCol = col == unCol(i);
    rows = row(indCol);
    vLength = max(rows) - min(rows);
    if vLength > maxVertLength
        maxVertLength = vLength;
        maxVertCol = unCol(i);
    end
end

end

