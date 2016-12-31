function [ final_segmentation ] = isolate_band_for_seeds( body_seg,final_segmentation )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    for i = 1:size(body_seg, 3)
        body_seg(:,:,i)= bwconvhull(body_seg(:,:,i));
        my_percent = sum(final_segmentation(:,:,i))/sum(body_seg(:,:,i));
        if my_percent>0.35
            final_segmentation(:,:,i)=0;
        end
    end
end

