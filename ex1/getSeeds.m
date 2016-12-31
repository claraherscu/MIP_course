function [ seeds ] = getSeeds ( volume, roiSeg )
%GETSEEDS function for extracting N seed points from ROI
%   uses the mean and standard deviation

% thresholding over 0
roi = int16(roiSeg).*int16(volume);
% finding mean and std of grey values in the ROI 
roiMean = mean(roi(roi>0));
roiStd = std(double(roi(roi>0)));
seeds = ((roi > roiMean) & (roi < roiMean + roiStd));

end


