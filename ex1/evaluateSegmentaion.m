function [ VDO ] = evaluateSegmentaion ( segmentationFilename, groundTruthFilename )
% EVALUATESEGMENTATION a function for validating the quality of the 
% segmentation
%   returns volumetric overlap difference
    
    % loading segmentation file
    niiStruct = load_untouch_nii_gzip(segmentationFilename);
    segmentation = niiStruct.img;
    
    % loading ground truth file
    niiStruct = load_untouch_nii_gzip(groundTruthFilename);
    groundTruth = niiStruct.img;

    % creating a bounding box around segmentation
    gt = bwconncomp(groundTruth, 26);
    stats = regionprops(gt,'BoundingBox');
    bBox = stats.BoundingBox;
    x = round(bBox(1)); x_width = round(bBox(4));
    y = round(bBox(2)); y_width = round(bBox(5));
    z = round(bBox(3)); z_width = round(bBox(6));

    % taking relevant parts from both images
    bBoxGroundTruth = groundTruth(y:y+y_width,x:x+x_width,z:z+z_width);
    bBoxSeg = segmentation(y:y+y_width,x:x+x_width,z:z+z_width);

    % calculating VDO
    union = bBoxGroundTruth | bBoxSeg;
    overlap = bBoxGroundTruth & bBoxSeg;
    VDO = (1-nnz(overlap)/nnz(union))*100;
end

