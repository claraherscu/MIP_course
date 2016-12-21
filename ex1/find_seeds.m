function [ seeds ] = find_seeds( segmentation ,original_image )
% finding seeds by mean and standard deviation

    %finding the original values of the image with the segmentation instead
    %of logical values.
    roi = int16(segmentation).*original_image;
    roi_mean = mean(roi(roi>0));
    roi_std = std(double(roi(roi>0)));
    searching_point= roi_mean+roi_std;
    seeds = (roi>searching_point-10 & roi < searching_point+10);

end

