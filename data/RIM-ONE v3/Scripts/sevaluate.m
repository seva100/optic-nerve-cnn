function [jaccard, dice, rfp, rfn]=sevaluate(gt, segm)
% gets label matrix for one region in segmented and ground truth 
% and returns the similarity indices
% gt is a region of a ground truth segmentation
% segm is the same region in segmented image
% rfp false pasitive ratio
% rfn false negative ratio
gt=gt(:);
segm=segm(:);
common=sum(gt & segm); 
union=sum(gt | segm); 
sumGt=sum(gt); % the number of voxels in m
sumSegm=sum(segm); % the number of voxels in o
jaccard=common/union;
dice=(2*common)/(sumGt+sumSegm);
rfp=(sumSegm-common)/sumGt;
rfn=(sumGt-common)/sumGt;

