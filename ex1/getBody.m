function [ bodySeg ] = getBody( volume )
%GETBODY isolates the patients body from the air and scans gantry
%   steps: 1. thresholding; 2. noise filtering;

display('started body segmentation');

% thresholding: remove all pixels with grey level below -500 and above 2000
minTh = -500;
maxTh = 2000;
temp_img = volume;
% unwanted_pixels = volume < minTh | volume > maxTh;
temp_img(volume < minTh | volume > maxTh) = 0;

% noise filtering: dilating img with imdilate 
SE = strel('disk', 5);
dilated_img = imdilate(temp_img, SE);

% returning the largest connected component
CC = bwconncomp(dilated_img, 26);
numPixels = cellfun(@numel,CC.PixelIdxList);
[~, idx] = max(numPixels);
bodySeg = zeros(size(volume));
bodySeg(CC.PixelIdxList{idx}) = 1;

end


