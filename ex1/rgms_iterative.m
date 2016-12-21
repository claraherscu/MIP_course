function [ segmentation ] = rgms_iterative( roi, original_image )
%RGMS-ITERATIVE Summary of this function goes here
%   Detailed explanation goes here
    
    new_roi = selectComponent(rgms(roi, original_image));
    differences = and(new_roi,not(roi));
    old_sum=0;
    new_sum = sum(differences(:));
    while (new_sum-old_sum>1)
        
        
        roi = new_roi;
        new_roi = rgms(new_roi, original_image);
        differences = and(new_roi,not(roi));
        old_sum=new_sum;
        new_sum = sum(differences(:));
%         %imagine_v2(original_image,new_roi,'temp');
    end
    segmentation = new_roi;

end

