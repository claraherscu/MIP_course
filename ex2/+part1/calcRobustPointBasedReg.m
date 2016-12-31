function [rigidReg, inliers] = calcRobustPointBasedReg( fixedPoints, movingPoints )
% CALCROBUSTPOINTBASEDREG Calculates a point based rigid registration
% despite of existance of outliuers, using ransac1 function.

%     N = size(fixedPoints,1);
%     minPtnum = 3;
%     iterNum = nchoosek(N,3);
%     thDist = 7;
%     thInlrRatio = 3/5;
%     
%     ransacCoef = struct('minPtNum', minPtnum, 'iterNum', iterNum, ...
%         'thDist', thDist, 'thInlrRatio', thInlrRatio);
%     funcFindF = @part1.calcPointBasedReg;
%     funcDist = @(f1, x, y) part1.calcDist(x, y, f1);
%     
%     [rigidReg, inliers] = utils.ransac.ransac1(fixedPoints, movingPoints, ...
%         ransacCoef, funcFindF, funcDist);
    
    ransacParams = struct('minPtNum', 3, ...
                      'iterNum', nchoosek(size(fixedPoints, 1), 3), ...
                      'thDist', 5, ...
                      'thInlrRatio', 3/5);
                  
    [rigidReg, inliers] = ...
    utils.ransac.ransac1(fixedPoints, movingPoints, ransacParams, ...
    @part1.calcPointBasedReg, @(f1, x, y) part1.calcDist(x, y, f1));

end