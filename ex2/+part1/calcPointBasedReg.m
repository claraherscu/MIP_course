function rigidReg = calcPointBasedReg(fixedPoints, movingPoints)
% CALCPOINTBASEDREG calculates the registration parameters for given points
%   rigidReg is a 3X3 matrix, which values' are ones so that if you apply
%   the transformation on movingPoints we get points as close as possible
%   (measured with least squares) to fixedPoints.
%   to get the rotation, executes the following steps: 
%       1. Compute the centroids of both point sets
%       2. Compute the centered vectors
%       3. Compute the 2 ª 2 covariance matrix
%       4. Compute the singular value decomposition S = U?V^T
%   the rotation is given using V and U^T
%   the translation vector is given by movingPoints - R*fixedPoints

% 1. Compute the centroids of both point sets
% all points have the same weight
fixedCentroid = mean(fixedPoints);
movingCentroid = mean(movingPoints);

% 2. Compute the centered vectors
centeredFixed = fixedPoints - fixedCentroid(ones(size(fixedPoints,1),1),:);
centeredMoving = movingPoints - movingCentroid(ones(size(movingPoints,1),1),:);

% 3. Compute the 2 ª 2 covariance matrix
covariance = transpose(centeredMoving) * diag(ones(size(centeredMoving,1),1)) * ...
    centeredFixed;

% 4. Compute the singular value decomposition S = U?V^T
[U, ~, V] = svd(covariance);

% Compute the rotation
determinant = det(V * transpose(U));
diagMatrix = diag([1 determinant]);
rotationMatrix = V * diagMatrix * transpose(U);

% Compute the translation
temp = rotationMatrix * transpose(movingCentroid);
translation = fixedCentroid - transpose(temp);

% Construct the rigidReg Matrix: [R 0; t 1]
rigidReg = [transpose(rotationMatrix) [0; 0]; translation 1];

end