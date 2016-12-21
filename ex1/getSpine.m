function [ spineSeg ] = getSpine( volume, aortaSeg, bodySeg )
%GETSPINE get the segmentation of the spine based on the segmentation of
%the aorta
%   the aorta gives us a good estimator for the location (in the x,y axes)
%   of the spine. we can "crop" the volume to concentrate on the correct
%   part of the volume and look for the spine

spineSeg=zeros(size(bodySeg));
for i=1:size(bodySeg,3)
    [x1, y1] = find(aortaSeg(:,:,i)==1,1,'first');
    [x2, ~] = find(aortaSeg(:,:,i)==1,1,'last');
    spineSeg(x1-60:x2+60,y1-125:y1-10,i)=1;
end
spineSeg = and(spineSeg,bodySeg);
spineSeg = spineSeg & bodySeg;

end

%% just in case i will need this for part 3
% function [ spineSeg ] = getSpine( volume, aortaSeg )
% %GETSPINE get the segmentation of the spine based on the segmentation of
% %the aorta
% %   the aorta gives us a good estimator for the location (in the x,y axes)
% %   of the spine. we can "crop" the volume to concentrate on the correct
% %   part of the volume and look for the spine
% 
% % find the reference indices according to which we'll "crop" the volume
% for i = 1:size(aortaSeg, 3)
%     if (find(aortaSeg(:,:,i), 1))
%         break;
%     end
% end
% 
% display(['aorta found at slice', num2str(i)]);
% [first_aorta_col, first_aorta_row] = find(aortaSeg(:,:,i),1);
% display(['aorta location found:', num2str(first_aorta_col), ', ', ...
%     num2str(first_aorta_row)]);
% 
% % the upper bound of the ROI is the first row, the lower bound is 1
% % the left bound is first col - 100, and the rigth is first col + 100
% % i will set to 0 everything out of this range
% spineSeg = volume;
% leftBound = max(1, first_aorta_col - 60);
% rightBound = min(first_aorta_col + 60, size(volume, 1));
% 
% spineSeg(1:leftBound,:,:) = 0;
% spineSeg(rightBound:size(volume, 1),:,:) = 0;
% spineSeg(:,first_aorta_row:size(volume, 2),:) = 0;
% spineSeg(find(aortaSeg)) = 0;
% 
% seeds_row = first_aorta_row - 50;
% seeds_col = first_aorta_col;
% all_optional_seeds = spineSeg(seeds_col, seeds_col, :);
% all_optional_seeds = all_optional_seeds(:);
% seed_slice = find(all_optional_seeds == mean(all_optional_seeds), 1);
% display(seed_slice);
% spineSeg = RegionGrowing1(spineSeg, 100, [seeds_col, seeds_row, seed_slice]);
% 
% % 
% % % now i can use simple thresholding in order to find the spine
% % minTh = 120;
% % maxTh = 500;
% % spineSeg = spineSeg > minTh & spineSeg < maxTh;
% % 
% % the largest connected component
% CC = bwconncomp(spineSeg, 26);
% numPixels = cellfun(@numel,CC.PixelIdxList);
% [~, idx] = max(numPixels);
% spineSeg = zeros(size(volume));
% spineSeg(CC.PixelIdxList{idx}) = 1;
% 
% % noise filtering: dilating img with imdilate 
% SE = strel('cube', 3);
% spineSeg = imdilate(spineSeg, SE);
% spineSeg = imerode(spineSeg, SE);
% 
% end
% % 
% seeds_row = first_aorta_row - 50;
% seeds_col = first_aorta_col;
% all_optional_seeds = spineSeg(seeds_col, seeds_row, :);
% all_optional_seeds = all_optional_seeds(:);
% [~, seed_slice] = min(abs(all_optional_seeds - mean(all_optional_seeds)));
% display(['initialized seed at: ', num2str(seeds_col), '|', ...
%     num2str(seeds_row), '|', num2str(seed_slice)]);
% spineSeg = RegionGrowing1(spineSeg, 100, [seeds_col, seeds_row, seed_slice]);
% 
% % the largest connected component
% CC = bwconncomp(spineSeg, 26);
% numPixels = cellfun(@numel,CC.PixelIdxList);
% [~, idx] = max(numPixels);
% spineSeg = zeros(size(volume));
% spineSeg(CC.PixelIdxList{idx}) = 1;
% 
% % noise filtering: dilating img with imdilate 
% SE = strel('cube', 2);
% spineSeg = imdilate(spineSeg, SE);
% spineSeg = imerode(spineSeg, SE);

%% saving for later
% % find the reference indices according to which we'll "crop" the volume
% for i = 1:size(aortaSeg, 3)
%     if (find(aortaSeg(:,:,i), 1))
%         break;
%     end
% end
% 
% display(['aorta found at slice ', num2str(i)]);
% [first_aorta_col, first_aorta_row] = find(aortaSeg(:,:,i),1);
% display(['aorta location found: ', num2str(first_aorta_col), ', ', ...
%     num2str(first_aorta_row)]);
% 
% % the upper bound of the ROI is the first row, the lower bound is 1
% % the left bound is first col - 10, and the rigth is first col + 10
% % i will set to 0 everything out of this range
% spineSeg = ones(size(volume));
% leftBound = max([1, first_aorta_col - 10]);
% rightBound = min([first_aorta_col + 0, size(volume, 1)]);
% 
% spineSeg = spineSeg(leftBound:rightBound, 
% 
% spineSeg(1:leftBound,:,:) = 0;
% spineSeg(rightBound:size(volume, 1),:,:) = 0;
% spineSeg(:,first_aorta_row - 10:size(volume, 2),:) = 0;
% spineSeg(:,1:first_aorta_row - 100,:) = 0;
% spineSeg(find(aortaSeg)) = 0;
% 
% spineSeg = spineSeg & bodySeg;

