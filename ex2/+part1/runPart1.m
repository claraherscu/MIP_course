% get the pictures
load brain.mat;

%% task1
% get the points on them
[fixedPoints,movingPoints] = utils.getPoints('no_outliers');

part1.showPointsOnPictures(brain_fixed, brain_moving, fixedPoints, movingPoints);

rigidReg = part1.calcPointBasedReg(fixedPoints, movingPoints)
% % check if this is a good transformation
% N = size(movingPoints,1);
% dist = [movingPoints ones(N,1)] * rigidReg - [fixedPoints ones(N,1)];
% display(num2str(dist));

distPixels = part1.calcDist(fixedPoints, movingPoints, rigidReg);
display(distPixels);

tform = affine2d(rigidReg);
part1.showRegistrationResult(tform);

% % repeat for outliers
% get the points on them
[fixedPoints,movingPoints] = utils.getPoints('with_outliers');

part1.showPointsOnPictures(brain_fixed, brain_moving, fixedPoints, movingPoints);

rigidReg = part1.calcPointBasedReg(fixedPoints, movingPoints)
% % check if this is a good transformation
% N = size(movingPoints,1);
% dist = [movingPoints ones(N,1)] * rigidReg - [fixedPoints ones(N,1)];
% display(num2str(dist));

distPixels = part1.calcDist(fixedPoints, movingPoints, rigidReg);
display(distPixels);

tform = affine2d(rigidReg);
part1.showRegistrationResult(tform);

[rigidReg, inliers] = part1.calcRobustPointBasedReg( fixedPoints, movingPoints );
tform = affine2d(rigidReg);
part1.showRegistrationResult(rigidReg);

%% task 2
% A = brain_fixed;
% B = brain_moving;
% RA = imref2d(size(A));
% RB = imref2d(size(B));
% [optimizer,metric] = imregconfig('monomodal');
% tform = imregtform(A,RA,B,RB,'rigid',optimizer,metric);
% 
% part1.showRegistrationResult(tform);
% 
% crossCorr = normxcorr2(A, B);
% transformedBrain = imwarp(brain_moving,tform);
% crossCorrAfter = normxcorr2(A, transformedBrain);
% display(sum(crossCorr(:)));
% display(sum(crossCorrAfter(:)));

