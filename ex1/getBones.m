function [ bonesSeg ] = getBones( volume, index, i_min, components )
%GETBONES a function for segmenting the bones
%   uses simple thresholding technique, also plots the graph of connected 
%   components for every i_min.

% initializing max threshold : 1300
i_max = 1300;

% plotting
X = 150:5:500;
subplot(2, 3, index);
plot(X, components);

% creating initial bones segmentation
temp_img = volume < i_max & volume > i_min;

% using morphological operators
SE = strel('cube', 2);
dilated = imdilate(temp_img, SE);
temp_img = imerode(dilated, SE);


% only bones get the value of 1, the rest will be 0
minConnCompTH = 20000;
CC = bwconncomp(temp_img, 26);
labels = labelmatrix(CC);
areas = regionprops(CC, 'Area');
bonesSeg = ismember(labels, find([areas.Area] >= minConnCompTH));

end

