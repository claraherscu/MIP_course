% get the pictures
load brain.mat;

%% task1
% % get the points on them
% [fixedPoints,movingPoints] = utils.getPoints('no_outliers');
% 
% part1.showPointsOnPictures(brain_fixed, brain_moving, fixedPoints, movingPoints);
% 
% rigidReg = part1.calcPointBasedReg(fixedPoints, movingPoints)
% % % check if this is a good transformation
% % N = size(movingPoints,1);
% % dist = [movingPoints ones(N,1)] * rigidReg - [fixedPoints ones(N,1)];
% % display(num2str(dist));
% 
% distPixels = part1.calcDist(fixedPoints, movingPoints, rigidReg);
% display(distPixels);
% 
% tform = affine2d(rigidReg);
% part1.showRegistrationResult(brain_fixed, brain_moving, tform);
% 
% % % repeat for outliers
% get the points on them
% [fixedPoints,movingPoints] = utils.getPoints('with_outliers');
% 
% part1.showPointsOnPictures(brain_fixed, brain_moving, fixedPoints, movingPoints);
% 
% rigidReg = part1.calcPointBasedReg(fixedPoints, movingPoints);
% % check if this is a good transformation
% N = size(movingPoints,1);
% dist = [movingPoints ones(N,1)] * rigidReg - [fixedPoints ones(N,1)];
% display(num2str(dist));

% distPixels = part1.calcDist(fixedPoints, movingPoints, rigidReg);
% display(distPixels);

% tform = affine2d(rigidReg);
% part1.showRegistrationResult(brain_fixed, brain_moving, tform);


% repeating for robust registration
% get the points
% [fixedPoints,movingPoints] = utils.getPoints('with_outliers');
% part1.showPointsOnPictures(brain_fixed, brain_moving, fixedPoints, movingPoints);
% use robust reg
% [rigidReg, inliers] = part1.calcRobustPointBasedReg( fixedPoints, movingPoints );
% display(rigidReg);
% display(part1.calcDist(fixedPoints, movingPoints, rigidReg));
% tform = affine2d(rigidReg);
% part1.showRegistrationResult(brain_fixed, brain_moving, tform);
% part1.showRegResultsWithOutliers(brain_fixed, brain_moving, tform, fixedPoints, movingPoints, rigidReg)

%% task 2
% A = brain_fixed;
% B = brain_moving;
% RA = imref2d(size(A));
% RB = imref2d(size(B));
% [optimizer,metric] = imregconfig('monomodal');
% tform = imregtform(B,RB,A,RA,'rigid',optimizer,metric);
% 
% part1.showRegistrationResult(brain_fixed, brain_moving, tform);
% 
% crossCorr = normxcorr2(A, B);
% transformedBrain = imwarp(brain_moving,tform);
% crossCorrAfter = normxcorr2(A, transformedBrain);
% figure;
% subplot(1,2,1), surf(crossCorr), shading flat, title('before Registration');
% subplot(1,2,2), surf(crossCorrAfter), shading flat, title('after Registration');
% ncc_before = crossCorr(round(size(crossCorr,1)/2),round(size(crossCorr,2)/2 ))
% ncc_after = crossCorrAfter(round(size(crossCorrAfter,1)/2),round(size(crossCorrAfter,2)/2 ))

% 3d:
T1 = utils.getScan('T1');
T2_rot_n = utils.getScan('T2_rot_n');

% doing registraion
[optimizer, metric] = imregconfig('multimodal');    
metric.NumberOfSpatialSamples = 1000;
optimizer.MaximumIterations = 500;
optimizer.Epsilon = 1.5e-4;
optimizer.GrowthFactor = 1.01;

A = T1.img;
B = T2_rot_n.img;
RA = T1.ref;
RB = T2_rot_n.ref;
tform = imregtform(B, RB, A, RA, 'rigid', optimizer, metric);
% showing some slices
% part1.showRegistrationResults3d ( A, B, tform, RB );

% showing histograms
% part1.showHistograms ( A, B, tform, RB );
% calculating nmi - doesn't work yet
nmi_before = part1.calcNMI(A, B);
transformedBrain = imwarp(B, RB, tform, 'outputView', RB);
nmi_after = part1.calcNMI(A, transformedBrain);
display(['nmi before registration is: ' num2str(nmi_before)]);
display(['nmi after registration is: ' num2str(nmi_after)]);