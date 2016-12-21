function [ segmentation ] = ribsRegionGrowing( seeds, volume)
%REGIONGROWING implementation of multiple-seeded region growing
%   1. extract N=200 seed points inside ROI
%   2. perform region growing with these initial points

    % shuffling in order to randomly use only 200 seeds
    ind = find(seeds);
    ix = randperm(length(ind));
    indShuff = ind(ix);
    [x,y,z] = ind2sub(size(seeds),indShuff);
    segmentation = zeros(size(seeds));
    
    howManySeeds = min(200,length(ind));
    for i = 1:howManySeeds
        seed = zeros(size(seeds));
        seed(x(i),y(i),z(i)) = 1;
        newRoi = (rgms(seed, volume));
        differences = and(newRoi,not(seed));
        old_sum=0;
        new_sum = sum(differences(:));
        while (new_sum-old_sum>1)    
            seed = newRoi;
            newRoi = (rgms(newRoi, volume));
            differences = and(newRoi,not(seed));
            old_sum=new_sum;
            new_sum = sum(differences(:));
        end
        temp_seg = newRoi;
        segmentation = or(segmentation,temp_seg);
    end
    SE = strel('cube', 3);
    segmentation = imerode(segmentation,SE);
    segmentation = imdilate(segmentation,SE);
end


%%saving just in case
%     newRoi = rgms(roiSeg, original_image);
%     
%     % selecting the largest connected component
%     CC = bwconncomp(newRoi, 26);
%     numPixels = cellfun(@numel,CC.PixelIdxList);
%     [~, idx] = max(numPixels);
%     newRoi = zeros(size(volume));
%     newRoi(CC.PixelIdxList{idx}) = 1;
%     
%     differences = and(newRoi,not(roiSeg));
%     oldSum = 0;
%     newSum = sum(differences(:));
%     while (newSum - oldSum > 1)
%         roiSeg = newRoi;
%         newRoi = rgms(newRoi, original_image);
%         differences = and(newRoi, not(roiSeg));
%         oldSum = newSum;
%         newSum = sum(differences(:));
%     end
%     bonesSeg = newRoi;

