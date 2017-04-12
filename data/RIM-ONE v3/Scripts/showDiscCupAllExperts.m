function [files, cdrVert, cdrArea] = showDiscCupAllExperts( imgDir, maskDir, outDir, numExperts )
% Shows the contour of disc and cup masks of the two experts on top of the
% images to compare their segmentations

files = dir(fullfile(imgDir, '*.jpg'));
mkdir(outDir)

colorsCup = [0 255 0;
    0 0 255];

colorsDisc = [255 255 255;
    0 0 0];

cdrVert = zeros(numExperts, length(files));
cdrArea = zeros(numExperts, length(files));

for i = 1:length(files)
    imgName = files(i).name;
    disp(imgName);
    img = imread(fullfile(imgDir, imgName));
    
    for k = 1:numExperts
        masksCup = dir(fullfile(maskDir, [imgName(1:end-4) '*Cup-exp' num2str(k) '.mat']));
        
        [ finalMaskCup ] = findLastMask( masksCup );
        
        if ~isempty(finalMaskCup)
            load(fullfile(maskDir, finalMaskCup));
            cup = mask;
            
            [ img ] = addContourToImg( img, cup, colorsCup(k,:) );
        end
        
        masksDisc = dir(fullfile(maskDir, [imgName(1:end-4) '*Disc-exp' num2str(k) '.mat']));
        
        [ finalMaskDisc ] = findLastMask( masksDisc );
        
        if ~isempty(finalMaskDisc)
            load(fullfile(maskDir, finalMaskDisc));
            disc = mask;
            
            [ img ] = addContourToImg( img, disc, colorsDisc(k,:) );
        end
        
        [ maxVertLengthDisc, ~ ] = getMaxVerticalLength( disc );
        [ maxVertLengthCup, ~ ] = getMaxVerticalLength( cup );
        cdRatioVert = maxVertLengthCup / maxVertLengthDisc;
        
        cdRatioArea = sum(cup(:)) / sum(disc(:));
        
        cdrVert(k, i) = cdRatioVert;
        cdrArea(k, i) = cdRatioArea;
    end

    imwrite(img, fullfile(outDir, [imgName(1:end-4) '-disc-cup-experts.png']));
end


end