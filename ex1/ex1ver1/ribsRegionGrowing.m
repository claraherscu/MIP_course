function [ segmentation ] = ribsRegionGrowing( seeds, volume, segmentation)
%REGIONGROWING implementation of multiple-seeded region growing
%   perform region growing with these initial points

    % shuffling in order to randomly use only 200 seeds
    ind = find(seeds);
    ix = randperm(length(ind));
    indShuff = ind(ix);
    [x,y,z] = ind2sub(size(seeds),indShuff);
    
    howManySeeds = min(100,length(ind));
    for i = 1:howManySeeds
        seed = zeros(size(seeds));
        seed(x(i),y(i),z(i)) = 1;
        newRoi = (rgms(seed, volume));
        
        seedSegIntersection = seed & segmentation;
        if (sum(seedSegIntersection(:)) > 0)
            continue;
        end
        
        differences = and(newRoi,not(seed));
        old_sum=0;
        new_sum = sum(differences(:));
        
        while (new_sum-old_sum>1)    
            seed = newRoi;
            newRoi = (rgms(newRoi, volume));
            
            differences = and(newRoi,not(seed));
            old_sum = new_sum;
            new_sum = sum(differences(:));
        end
        temp_seg = newRoi;
        segmentation = or(segmentation,temp_seg);
    end
    
    segmentation = segmentation | (volume > 500);
end

