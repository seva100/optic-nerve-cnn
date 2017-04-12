%REPRODUCERESULTS This script reproduces the results of the paper
% "Interactive tool and database for optic disc and cup segmentation of 
% stereo and monocular retinal fundus images", F. Fumero, J. Sigut, 
% S. Alayón, M. González-Hernández, M. González de la Rosa, 2015
%
% NOTE: It may take around half an hour to finish computation

addpath('radius_variability');

% Convert the DCSeg txt files to interpolated binary masks in MAT and PNG
% format
dirDCSeg2InterpMask( '..\Healthy\Stereo Images', '..\Healthy\Expert1_masks', '..\Healthy\Test\Experts_masks_test', [] );
dirDCSeg2InterpMask( '..\Healthy\Stereo Images', '..\Healthy\Expert2_masks', '..\Healthy\Test\Experts_masks_test', [] );
dirDCSeg2InterpMask( '..\Glaucoma and suspects\Stereo Images', '..\Glaucoma and suspects\Expert1_masks', '..\Glaucoma and suspects\Test\Experts_masks_test', [] );
dirDCSeg2InterpMask( '..\Glaucoma and suspects\Stereo Images', '..\Glaucoma and suspects\Expert2_masks', '..\Glaucoma and suspects\Test\Experts_masks_test', [] );

% Compute the average masks from the DCSeg txt files
averageMaskFromExperts( '..\Healthy\Stereo Images', '..\Healthy\Expert1_masks', '..\Healthy\Expert2_masks', '..\Healthy\Test\Average_masks_test' );
averageMaskFromExperts( '..\Glaucoma and suspects\Stereo Images', '..\Glaucoma and suspects\Expert1_masks', '..\Glaucoma and suspects\Expert2_masks', '..\Glaucoma and suspects\Test\Average_masks_test' );

% Convert the average masks in txt to interpolated binary masks
dirDCSeg2InterpMask( '..\Healthy\Stereo Images', '..\Healthy\Test\Average_masks_test', '..\Healthy\Test\Average_masks_test', [] );
dirDCSeg2InterpMask( '..\Glaucoma and suspects\Stereo Images', '..\Glaucoma and suspects\Test\Average_masks_test', '..\Glaucoma and suspects\Test\Average_masks_test', [] );

% Show the disc and cup of the two experts on top of the images and get the
% cup-to-disc ratio of the vertical size of the disc and cup
[files, cdrVert, ~] = showDiscCupAllExperts( '..\Healthy\Stereo Images', '..\Healthy\Test\Experts_masks_test', '..\Healthy\Test\Experts_disc_cup_contours_test', 2 );
[filesG, cdrVertG, ~] = showDiscCupAllExperts( '..\Glaucoma and suspects\Stereo Images', '..\Glaucoma and suspects\Test\Experts_masks_test', '..\Glaucoma and suspects\Test\Experts_disc_cup_contours_test', 2 );

% Compute the evaluation measures: jaccard similarity index and variability
% percentage by radius
[ ~, jaccardDiscByImg, varRadDiscByImg, ~, ~, jaccardCupByImg, varRadCupByImg, ~ ] = variabilityAvgMaskDCSeg( '..\Healthy\Stereo Images', '..\Healthy\Test\Average_masks_test', '..\Healthy\Test\Experts_masks_test', 2 );
[ ~, jaccardDiscByImgG, varRadDiscByImgG, ~, ~, jaccardCupByImgG, varRadCupByImgG, ~ ] = variabilityAvgMaskDCSeg( '..\Glaucoma and suspects\Stereo Images', '..\Glaucoma and suspects\Test\Average_masks_test', '..\Glaucoma and suspects\Test\Experts_masks_test', 2 );

% Print the average results
fprintf('\n')

disp('Jaccard Index');
disp(['Disc Healthy: ' num2str(mean(mean(jaccardDiscByImg)), '%0.2f') ' (SD = ' num2str(std(mean(jaccardDiscByImg)), '%0.2f') ')']);
disp(['Disc Glaucoma: ' num2str(mean(mean(jaccardDiscByImgG)), '%0.2f') ' (SD = ' num2str(std(mean(jaccardDiscByImgG)), '%0.2f') ')']);
disp(['Cup Healthy: ' num2str(mean(mean(jaccardCupByImg)), '%0.2f') ' (SD = ' num2str(std(mean(jaccardCupByImg)), '%0.2f') ')']);
disp(['Cup Glaucoma: ' num2str(mean(mean(jaccardCupByImgG)), '%0.2f') ' (SD = ' num2str(std(mean(jaccardCupByImgG)), '%0.2f') ')']);

fprintf('\n')

disp('Average Variability Percentage');
disp(['Disc Healthy: ' num2str(mean(mean(varRadDiscByImg)), '%0.2f') ' (SD = ' num2str(std(mean(varRadDiscByImg)), '%0.2f') ')']);
disp(['Disc Glaucoma: ' num2str(mean(mean(varRadDiscByImgG)), '%0.2f') ' (SD = ' num2str(std(mean(varRadDiscByImgG)), '%0.2f') ')']);
disp(['Cup Healthy: ' num2str(mean(mean(varRadCupByImg)), '%0.2f') ' (SD = ' num2str(std(mean(varRadCupByImg)), '%0.2f') ')']);
disp(['Cup Glaucoma: ' num2str(mean(mean(varRadCupByImgG)), '%0.2f') ' (SD = ' num2str(std(mean(varRadCupByImgG)), '%0.2f') ')']);

fprintf('\n')

disp('Vertical Cup-to-Disc ratio (VCDR)');
meanVCDR = mean(cdrVert, 2);
stdVCDR = std(cdrVert, [], 2);
corrCoefHealthy = corrcoef(cdrVert(1,:), cdrVert(2,:));
meanVCDRG = mean(cdrVertG, 2);
stdVCDRG = std(cdrVertG, [], 2);
corrCoefGlaucoma = corrcoef(cdrVertG(1,:), cdrVertG(2,:));

disp(['VCDR Healthy Expert 1: ' num2str(meanVCDR(1), '%0.2f') ' (SD = ' num2str(stdVCDR(1), '%0.2f') ')']);
disp(['VCDR Healthy Expert 2: ' num2str(meanVCDR(2), '%0.2f') ' (SD = ' num2str(stdVCDR(2), '%0.2f') ')']);
disp(['VCDR Healthy Correlation Coefficient: ' num2str(corrCoefHealthy(1,2), '%0.2f')]);
disp(['VCDR Glaucoma Expert 1: ' num2str(meanVCDRG(1), '%0.2f') ' (SD = ' num2str(stdVCDRG(1), '%0.2f') ')']);
disp(['VCDR Glaucoma Expert 2: ' num2str(meanVCDRG(2), '%0.2f') ' (SD = ' num2str(stdVCDRG(2), '%0.2f') ')']);
disp(['VCDR Glaucoma Correlation Coefficient: ' num2str(corrCoefGlaucoma(1,2), '%0.2f')]);


% Test the significance of the results
fprintf('\n')

disp('Two-sample t-test results');

fprintf('\n')

[h,p] = ttest2(mean(jaccardDiscByImg), mean(jaccardDiscByImgG));
printTestResult( p, 'the Jaccard index of the disc for the healthy and glaucoma group' );

[h,p] = ttest2(mean(jaccardCupByImg), mean(jaccardCupByImgG));
printTestResult( p, 'the Jaccard index of the cup for the healthy and glaucoma group' );

fprintf('\n')

[h,p] = ttest2(mean(varRadDiscByImg), mean(varRadDiscByImgG));
printTestResult( p, 'the Average Variability Percentage of the disc for the healthy and glaucoma group' );

[h,p] = ttest2(mean(varRadCupByImg), mean(varRadCupByImgG));
printTestResult( p, 'the Average Variability Percentage of the cup for the healthy and glaucoma group' );

fprintf('\n')

[h,p] = ttest2(cdrVert(1,:), cdrVert(2,:));
printTestResult( p, 'the VCDR of the two experts for healthy subjects' );

[h,p] = ttest2(cdrVertG(1,:), cdrVertG(2,:));
printTestResult( p, 'the VCDR of the two experts for glaucoma patients' );

fprintf('\n')

[h,p] = ttest2(mean(cdrVert), mean(cdrVertG));
printTestResult( p, 'the VCDR of the healthy group and glaucoma and glaucoma suspects group' );

[h,p] = ttest2(mean(cdrVert), mean(cdrVertG(:,1:39)));  % the confirmed glaucoma cases go from the 1 to the 39 position
printTestResult( p, 'the VCDR of the healthy and glaucoma group' );

[h,p] = ttest2(mean(cdrVert), mean(cdrVertG(:,40:end)));    % the glaucoma suspects go from the 40 to the 74 position
printTestResult( p, 'the VCDR of the healthy and glaucoma suspects group' );


