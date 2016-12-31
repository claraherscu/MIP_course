function [ segmentation ] = regionGrowing( seeds, volume, CtType )
%REGIONGROWING implementation of multiple-seeded region growing
%   perform region growing with these initial points

    % getting the matrix of seeds
    segmentation = zeros(size(seeds));
    howManySeeds = 100;
    seedsToUse = datasample(find(seeds == 1), howManySeeds);

    % iterating untill convergence
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
    
    segmentation = segmentation | (volume > 500);
    if (strcmp(CtType, 'ABTH'))
        segmentation = segmentation | (volume > 200);
    end
    
    segmentationValues = int16(segmentation) .* int16(volume);
    segMean = mean(segmentationValues(:));
    if segMean > 100
        segmentation = segmentationValues > 100;
    end

    % filling holes
    segmentation = imfill(segmentation, 'holes');
end

