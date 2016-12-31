function [ segmentation ] = rgms( roi, original_image )
%RGMS region growing function
%   1. expanding the region of the seed
%   2. calculating mean and std
%   3. inserting only voxels with grey value close enough to nurmalized
%   mean to the new region.
    
    SE = strel('cube', 3);
    new_roi = imdilate(roi,SE);
    new_roi_values = int16(new_roi).*int16(original_image);
    
    roi_mean = mean(new_roi_values(new_roi_values>100));
    roi_std = std(double(new_roi_values(new_roi_values>100)));
    
    roi_distance = abs((double(new_roi_values)-roi_mean)/roi_std);
    roi_distance = roi_distance .* new_roi;
    
    new_roi=(roi_distance<1 & roi_distance>0 & new_roi_values>100);
    segmentation = new_roi;
end