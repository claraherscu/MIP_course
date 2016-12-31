function [ segmentation ] = rgms_iterative( seeds, original_image )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    ind = find(seeds);
    ix = randperm(length(ind));
    indShuff = ind(ix);
    [x,y,z] = ind2sub(size(seeds),indShuff);
    segmentation = zeros(size(seeds));
    for i = 1:200
        seed = zeros(size(seeds));
        seed(x(i),y(i),z(i)) = 1;
        new_roi = selectComponent(rgms(seed, original_image));
        differences = and(new_roi,not(seed));
        old_sum=0;
        new_sum = sum(differences(:));
        while (new_sum-old_sum>1)    
            seed = new_roi;
            new_roi = selectComponent(rgms(new_roi, original_image));
            differences = and(new_roi,not(seed));
            old_sum=new_sum;
            new_sum = sum(differences(:));
    %         %imagine_v2(original_image,new_roi,'temp');
        end
        temp_seg = new_roi;
        segmentation = or(segmentation,temp_seg);
    end
    SE = strel('cube', 3);
    segmentation = imerode(segmentation,SE);
    segmentation =selectComponent(segmentation);
    segmentation = imdilate(segmentation,SE);
end

