function [ diceDiscByImg, jaccardDiscByImg, varRadDiscByImg, varRadDiscByExp, diceCupByImg, jaccardCupByImg, varRadCupByImg, varRadCupByExp ] = variabilityAvgMaskDCSeg( imgDir, avgMaskDir, dcSegMaskDir, numExperts )
%VARIABILITYKOWADCSEG Summary of this function goes here
%   Detailed explanation goes here

files = dir(fullfile(imgDir, '*.jpg'));
maxFiles = length(files);
diceDiscByImg = zeros(2, maxFiles);
jaccardDiscByImg = zeros(2, maxFiles);
varRadDiscByImg = zeros(8, maxFiles);
varRadDiscByExp = cell(1, numExperts);
for j = 1:numExperts
    varRadDiscByExp{j} = zeros(8, maxFiles);
end

diceCupByImg = zeros(2, maxFiles);
jaccardCupByImg = zeros(2, maxFiles);
varRadCupByImg = zeros(8, maxFiles);
varRadCupByExp = cell(1, numExperts);
for j = 1:numExperts
    varRadCupByExp{j} = zeros(8, maxFiles);
end
% varRadDiscByImgAv = zeros(1, maxFiles);

for i = 1:maxFiles
    % Find Kowa Mask
    imgName = files(i).name;
    eyeSide = imgName(end-4);
    disp(imgName);
    avgFileDisc = [imgName(1:end-4) '-Disc-Avg.mat'];
    load(fullfile(avgMaskDir, avgFileDisc));
    avgDisc = mask;
    
    avgFileCup = [imgName(1:end-4) '-Cup-Avg.mat'];
    load(fullfile(avgMaskDir, avgFileCup));
    avgCup = mask;

    varRadExpDisc = zeros(8, numExperts);
    diceExpDisc = zeros(1, numExperts);
    jacExpDisc = zeros(1, numExperts);
    
    varRadExpCup = zeros(8, numExperts);
    diceExpCup = zeros(1, numExperts);
    jacExpCup = zeros(1, numExperts);
    for k = 1:numExperts
        % Disc
        masksDisc = dir(fullfile(dcSegMaskDir, [imgName(1:end-4) '*Disc-exp' num2str(k) '.mat']));
        [ finalMaskDisc ] = findLastMask( masksDisc );
        
        if ~isempty(finalMaskDisc)
            load(fullfile(dcSegMaskDir, finalMaskDisc));
            disc = mask;
            
            [ VPdisc ] = variabilityDCSeg( avgDisc, disc, eyeSide );
            
            varRadExpDisc(:, k) = VPdisc;
            varRadDiscByExp{k}(:,i) = VPdisc;
            
            [jaccard, dice, rfp, rfn]=sevaluate(avgDisc, disc);
            diceExpDisc(k) = dice;
            jacExpDisc(k) = jaccard;
        else
            varRadExpDisc(:, k) = NaN;
            diceExpDisc(k) = NaN;
            jacExpDisc(k) = NaN;
        end
        
        % Cup
        masksCup = dir(fullfile(dcSegMaskDir, [imgName(1:end-4) '*Cup-exp' num2str(k) '.mat']));
        [ finalMaskCup ] = findLastMask( masksCup );
        
        if ~isempty(finalMaskCup)
            load(fullfile(dcSegMaskDir, finalMaskCup));
            cup = mask;
            
            [ VPcup ] = variabilityDCSeg( avgCup, cup, eyeSide );
            
            varRadExpCup(:, k) = VPcup;
            varRadCupByExp{k}(:,i) = VPcup;
            
            [jaccard, dice, rfp, rfn]=sevaluate(avgCup, cup);
            diceExpCup(k) = dice;
            jacExpCup(k) = jaccard;
        else
            varRadExpCup(:, k) = NaN;
            diceExpCup(k) = NaN;
            jacExpCup(k) = NaN;
        end
    end
    
    diceDiscByImg(:,i) = diceExpDisc;
    jaccardDiscByImg(:,i) = jacExpDisc;
    varRadDiscByImg(:,i) = mean(varRadExpDisc, 2);
    
    diceCupByImg(:,i) = diceExpCup;
    jaccardCupByImg(:,i) = jacExpCup;
    varRadCupByImg(:,i) = mean(varRadExpCup, 2);
    
end


end

