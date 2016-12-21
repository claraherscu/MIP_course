function [ VD, VDO ] = evaluateSegmentaion ( segmentationFilename, groundTruthFilename )
% EVALUATESEGMENTATION a function for validating the quality of the 
% segmentation
%   returns volume difference and volume overlap difference
    
    % loading segmentation file
    niiStruct = load_untouch_nii_gzip(segmentationFilename);
    segmentation = niiStruct.img;
    
    % loading ground truth file
    niiStruct = load_untouch_nii_gzip(groundTruthFilename);
    groundTruth = niiStruct.img;
    
%     numPixelsGroundTruth = [];
%     for i = 1:size(groundTruth,3)
%         numPixelsGroundTruth(end+1) = sum(groundTruth(:,:,i));
%     end
%     
%     firstSlice = find(numPixelsGroundTruth, 'first');
%     lastSlice = find(numPixelsGroundTruth, 'last');
%     
%     segmentation = segmentation(:,:,firstSlice:lastSlice);

    CC = bwconncomp(groundTruth, 26);
    groundTruthStats = regionprops(CC, 'BoundingBox');
    bBox = groundTruthStats.BoundingBox;
    
    segmentation = segmentation(bBox(1,1):bBox(1,1)+bBox(1,2), ...
        bBox(2,1):bBox(2,1)+bBox(2,2), bBox(3,1):bBox(3,1)+bBox(3,2)); 

    overlap = and(segmentation, groundTruth);
    overlapVol = sum(overlap(:));
    
    segVol = sum(segmentation);
    groundVol = sum(groundTruth);
    
    VDO = 2*overlapVol / (segVol + groundVol);    
    VD = 0;

end

