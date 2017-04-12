function [ finalMask ] = findLastMask( masks )
%FINDLASTMASK Summary of this function goes here
%   Detailed explanation goes here

finalMask = [];
if ~isempty(masks)
    if length(masks) > 1
        lastMaskNum = 0;
        for j = 1:length(masks)
            maskstr = masks(j).name;
            masksplit = strsplit(maskstr, '-');
            maskNum = str2num(masksplit{end-2});
            if maskNum > lastMaskNum
                lastMaskNum = maskNum;
                finalMask = maskstr;
            end
        end
    else
        finalMask = masks(1).name;
    end
end

end

