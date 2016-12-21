function [ segmentation ] = rgms( roi, original_image )
%RGMS the function that computes one iteration of region growing
%   take the old ROI computed in the previous iteration and expand it in a
%   26-connectivity direction. then, for every cell, check if it satisfies
%   the homogenity criteria: delta(x) = abs(g(x)-mean(g(all)))/std(g(all)).
%   we want to take pixels satisfying 0 < delta(x) < 1.
    
%     SE = strel('cube', 3);
%     % selecting the largest connected component
% %     CC = bwconncomp(roi, 26);
% %     numPixels = cellfun(@numel,CC.PixelIdxList);
% %     [~, idx] = max(numPixels);
% %     roi = zeros(size(volume));
% %     roi(CC.PixelIdxList{idx}) = 1;
%     
%     oldRoiValues = int16(roi) .* int16(volume);
% 
%     newRoi = imdilate(roi,SE);
%     newRoiValues = int16(newRoi) .* int16(volume);
% %     newRoi = (newRoiValues > 100);
% %     newRoiValues = int16(newRoi) .* int16(volume);
% %     
% %     if sum(roi(roi > 0)) == 1
% %         % if this is the first time we run on this seed, we can't calculate
% %         % mean based only on one seed.
% %         roiMean = mean(newRoiValues(newRoiValues>0));
% %         roiStd = std(double(newRoiValues(newRoiValues>0)));
% %     else
% %         % otherwise, we'd like to calculate mean before adding new voxels.
% %         roiMean = mean(oldRoiValues(oldRoiValues>0));
% %         roiStd = std(double(oldRoiValues(oldRoiValues>0)));
% %     end
%     
%     roiMean = mean(newRoiValues(newRoiValues>0));
%     roiStd = std(double(newRoiValues(newRoiValues>0)));
%     
%     roiDistance = abs((double(newRoiValues) - roiMean) / roiStd);
%     roiDistance = roiDistance .* newRoi;
%     
%     newRoi = (roiDistance < 1 & roiDistance > 0);
%     newRoiValues = int16(newRoi) .* int16(volume);
%     segmentation = (newRoiValues > 100);
% %     segmentation = newRoi > 100;


    SE = strel('cube', 3);
    new_roi = imdilate(roi,SE);
    new_roi_values = int16(new_roi).*original_image;
    
    roi_mean = mean(new_roi_values(new_roi_values>0));
    roi_std = std(double(new_roi_values(new_roi_values>0)));
    
    roi_distance = abs((double(new_roi_values)-roi_mean)/roi_std);
    roi_distance = roi_distance .* new_roi;
    
    
    new_roi=(roi_distance<1 & roi_distance>0 & new_roi_values>100);
    segmentation = new_roi;

end

