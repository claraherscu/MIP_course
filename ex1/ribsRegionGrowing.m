function [ segmentation ] = ribsRegionGrowing( seeds, volume, segmentation)
%REGIONGROWING implementation of multiple-seeded region growing
%   perform region growing with these initial points

    % creating matrix of ribs seeds
    howManySeeds = 100;
    seedsToUse = datasample(find(seeds == 1), howManySeeds);

    % iterating until convergence
    seed = zeros(size(seeds));
    seed(seedsToUse) = 1;
    newRoi = rgms(seed, volume);
    differences = and(newRoi,not(seed));
    old_sum=0;
    new_sum = sum(differences(:));

    while (new_sum-old_sum>1)    
        seed = newRoi;
        newRoi = rgms(newRoi, volume);

        differences = and(newRoi,not(seed));
        old_sum = new_sum;
        new_sum = sum(differences(:));
    end
    temp_seg = newRoi;
    segmentation = or(segmentation,temp_seg);
    
    SE = strel('cube', 3);
    segmentation = imerode(segmentation,SE);
    segmentation = imdilate(segmentation,SE);

    % filling holes
    segmentation = imfill(segmentation, 'holes');
end

