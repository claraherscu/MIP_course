function [ lungsSeg, slices ] = getLungs ( bodySeg, CTtype )
%GETLUNGS isolating the breathing system (lungs)
%   isolate the largest holes - they are the lungs, and determine the
%   lower slice of the lungs and the slice where the lungs are the largest.

display('started lungs segmentation');

% first, finding all the holes in the body
allHolesIdxs = getHoles(bodySeg);

% step 2: find the biggest holes that aren't background, by selecting 
% second biggest connected component from the holes image. if the second
% component is not wide enough, we also take the third

% calculating body convhull width
bodyWidth = getConvWidth(bodySeg);

% greatest: this is the background so it's irrelevant
CC = bwconncomp(allHolesIdxs, 26);
numPixels = cellfun(@numel,CC.PixelIdxList);
[~, greatestHoleIdx] = max(numPixels);
% second greatest:
allHolesIdxs(CC.PixelIdxList{greatestHoleIdx}) = 0;
CC1 = bwconncomp(allHolesIdxs, 26);
numPixels = cellfun(@numel,CC1.PixelIdxList);
[~, secondGreatestHoleIdx] = max(numPixels);

lungsSeg = zeros(size(bodySeg));
lungsSeg(CC1.PixelIdxList{secondGreatestHoleIdx}) = 1;

% lungs should be at least 60% of the body width, if not, we should add the
% next largest component
if(getConvWidth(lungsSeg) < 0.6 * bodyWidth)
    % third greatest:
    allHolesIdxs(CC1.PixelIdxList{secondGreatestHoleIdx}) = 0;
    CC2 = bwconncomp(allHolesIdxs, 26);
    numPixels = cellfun(@numel,CC2.PixelIdxList);
    [~, thirdGreatestHoleIdx] = max(numPixels);
    lungsSeg(CC2.PixelIdxList{thirdGreatestHoleIdx}) = 1;
end

% step 3: find BB and CC - the minimal idx in the z axis that is not 0, and 
% the slice where the image has most pixels 'on', accordingly
[lowerLungSlice, centralLungSlices] = getLowerCenter(lungsSeg);
slices = [lowerLungSlice, centralLungSlices(1)];

end


%%
function [ holesIdxs ] = getHoles ( bodySeg )
% GETHOLES helper function for calculating the holes
%   calculate the area of the body and substract from it the area of the
%   non-zero pixels (not a hole)

CC = bwconncomp(bodySeg, 26);
bodyStats = regionprops(CC, 'FilledImage');

bodyConvHull = ones(size(bodySeg));
bodyConvHull(bodyStats.FilledImage) = 1;

holesIdxs = bodyConvHull - bodySeg;

end

%%
function [ lowerLungSlice, centralLungSlice] = getLowerCenter ( lungsSeg )
% GETLOWERCENTER find BB and CC
%    the minimal idx in the z axis that is not 0, and the slice where the 
%    image has most pixels 'on', accordingly

% running over all slices, counting pixels
lungPixels = zeros(size(lungsSeg, 3), 1);
for i = size(lungsSeg, 3):-1:1
    lungPixels(i) = numel(find(lungsSeg(:,:,i)));
end

% the smallest index where there is a lung pixel colored
[lowerLungSlice, ~] = find(lungPixels, 1);
% the index where number of lung pixels is maximal
[~, centralLungSlice] = max(lungPixels);

end

%%
function [ width ] = getConvWidth(X)
% Finds the width of the convhull
[x, y] = ind2sub(size(X), find(X));
if numel(x) == 0
    width = 0;
    return
end
idxs = convhull(x,y, 'simplify', true);
xh = x(idxs);
width = max(xh) - min(xh);
end