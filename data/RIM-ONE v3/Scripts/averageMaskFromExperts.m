function averageMaskFromExperts( imgDir, dcSegDir1, dcSegDir2, outDir )
%AVERAGEMASKFROMEXPERTS Makes an average mask from the expert segmentations
%of DCSeg

files = dir(fullfile(imgDir, '*.jpg'));
mkdir(outDir);
for i = 1:length(files)
    imgName = files(i).name;
    disp(imgName);
    
    % Expert 1
    % Cup
    masksCup = dir(fullfile(dcSegDir1, [imgName(1:end-4) '*Cup-exp1.txt']));
    [ finalMaskCup ] = findLastMask( masksCup );
    [ ~, ~, centerCup1, pointsCup1 ] = DCSeg2InterpMask( fullfile(imgDir, imgName), fullfile(dcSegDir1, finalMaskCup) );
    
    % Disc
    masksDisc = dir(fullfile(dcSegDir1, [imgName(1:end-4) '*Disc-exp1.txt']));
    [ finalMaskDisc ] = findLastMask( masksDisc );
    [ ~, ~, centerDisc1, pointsDisc1 ] = DCSeg2InterpMask( fullfile(imgDir, imgName), fullfile(dcSegDir1, finalMaskDisc) );
    
    % Expert 2
    % Cup
    masksCup = dir(fullfile(dcSegDir2, [imgName(1:end-4) '*Cup-exp2.txt']));
    [ finalMaskCup ] = findLastMask( masksCup );
    [ ~, ~, centerCup2, pointsCup2 ] = DCSeg2InterpMask( fullfile(imgDir, imgName), fullfile(dcSegDir2, finalMaskCup) );
    
    % Disc
    masksDisc = dir(fullfile(dcSegDir2, [imgName(1:end-4) '*Disc-exp2.txt']));
    [ finalMaskDisc ] = findLastMask( masksDisc );
    [ ~, ~, centerDisc2, pointsDisc2 ] = DCSeg2InterpMask( fullfile(imgDir, imgName), fullfile(dcSegDir2, finalMaskDisc) );
    
    % Average segmentation
    % Cup
    avgCupCenterX = round(mean([centerCup1{1}; centerCup2{1}]));
    avgCupCenterY = round(mean([centerCup1{2}; centerCup2{2}]));
    avgCupPointsX = round(mean([pointsCup1{1} pointsCup2{1}], 2));
    avgCupPointsY = round(mean([pointsCup1{2} pointsCup2{2}], 2));
    
    finalPointsCup = [avgCupCenterX avgCupCenterY;...
        avgCupPointsX avgCupPointsY];
    
    % Disc
    avgDiscCenterX = round(mean([centerDisc1{1}; centerDisc2{1}]));
    avgDiscCenterY = round(mean([centerDisc1{2}; centerDisc2{2}]));
    avgDiscPointsX = round(mean([pointsDisc1{1} pointsDisc2{1}], 2));
    avgDiscPointsY = round(mean([pointsDisc1{2} pointsDisc2{2}], 2));
    
    finalPointsDisc = [avgDiscCenterX avgDiscCenterY;...
        avgDiscPointsX avgDiscPointsY];
    
    % Transpose to prepare the matrix for the output
    finalPointsCup = finalPointsCup';
    finalPointsDisc = finalPointsDisc';
    
    % Write to output file as a column of points in the order:
    % center_x
    % center_y
    % x_IR3
    % y_IR3
    % x_IR34
    % y_IR34
    % ...
    
    % Cup
    outFileCup = fullfile(outDir, [imgName(1:end-4) '-Cup-Avg.txt']);
    fileid = fopen(outFileCup, 'w');
    fprintf(fileid, 'Intersection points\r\n');
    fclose(fileid);
    dlmwrite(outFileCup, finalPointsCup(:), '-append', 'delimiter', '\n', 'newline', 'pc');
    
    % Disc
    outFileDisc = fullfile(outDir, [imgName(1:end-4) '-Disc-Avg.txt']);
    fileid = fopen(outFileDisc, 'w');
    fprintf(fileid, 'Intersection points\r\n');
    fclose(fileid);
    dlmwrite(outFileDisc, finalPointsDisc(:), '-append', 'delimiter', '\n', 'newline', 'pc');
    
end


end

