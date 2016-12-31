function [ segmentation ] = regionGrowing( seeds, volume )
%REGIONGROWING implementation of multiple-seeded region growing
%   perform region growing with these initial points

    % shuffling in order to randomly use only 200 seeds
    ind = find(seeds);
    ix = randperm(length(ind));
    indShuff = ind(ix);
    [x,y,z] = ind2sub(size(seeds),indShuff);
    segmentation = zeros(size(seeds));
    
    howManySeeds = min(100,length(ind));
    for i = 1:howManySeeds
        seed = zeros(size(seeds));
        seed(x(i),y(i),z(i)) = 1;
        newRoi = rgms(seed, volume);
        
        seedSegIntersection = seed & segmentation;
        if (sum(seedSegIntersection(:)) > 0)
            continue;
        end
        
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
    end
    
    SE = strel('cube', 3);
    segmentation = imerode(segmentation,SE);
    segmentation = imdilate(segmentation,SE);
    
    segmentation = segmentation | (volume > 500);
    segmentationValues = int16(segmentation) .* int16(volume);
    
    segMean = mean(segmentationValues(:));
    if segMean > 100
        display('segmean > 100, removing anything under 100');
        segmentation = segmentationValues > 100;
    end

end

