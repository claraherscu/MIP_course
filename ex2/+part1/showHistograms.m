function showHistograms ( A, B, tform, RB )
% SHOWHISTOGRAMS a function that displays the joint histograms of two
% images A, B before and after applying the transformation tform on B

    figure;
    
    sp1 = subplot(1,2,1);
        [N, ~, ~] = histcounts2(A,B);
        imagesc(log10(N));
        axis xy equal;
        colorbar;
        title('Joint histogram before registration');
        xlabel('Image before transformation');
        ylabel('Original image');
        colorbar;
        
    sp2 = subplot(1,2,2);
        transformedBrain = imwarp(B, RB, tform, 'outputView', RB);
        [transformedN, ~, ~] = histcounts2(A,transformedBrain);
        imagesc(log10(transformedN));
        axis xy equal;
        title('Joint histogram after registration');
        xlabel('Transformed image');
        ylabel('Original image');
        colorbar;
        
    axis([sp1 sp2], [1 115 1 128]);
    
end

