clear; clc;

% get the pictures
load brain.mat;

% get the points on them
[fixedPoints,movingPoints] = utils.getPoints('no_outliers');

showPointsOnPictures(brain_fixed, brain_moving, fixedPoints, movingPoints);

