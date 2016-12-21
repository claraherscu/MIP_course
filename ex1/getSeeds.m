function [ seeds ] = getSeeds ( volume, roiSeg )
%GETSEEDS function for extracting N seed points from ROI
%   uses the mean and standard deviation

% thresholding over 0
roi = int16(roiSeg).*int16(volume);
% finding mean and std of grey values in the ROI 
roi_mean = mean(roi(roi>0));
roi_std = std(double(roi(roi>0)));
searching_point= roi_mean+roi_std;
seeds = (roi>searching_point-10 & roi < searching_point+10);

end


