function showRegistrationResults3d ( A, B, tform, RB )
% SHOWREGISTRATIONRESULT3D a function that displays some slices of the
% registrated 3d images
    
    transformedBrain = imwarp(B, RB, tform, 'outputView', RB);
    % show some slices of the pictures together
    slices = 10:10:size(A,3);
    slicesNum = length(slices);
    subplotNum = 1;
    linesNum = 2;
    figure;
    for slice = slices
        subplot(linesNum,slicesNum/2,subplotNum);
        imshowpair(transformedBrain(:,:,slice), A(:,:,slice));
        title(['slice #' num2str(slice)]);
        subplotNum = subplotNum + 1;
    end
    figure;
    subplotNum = 1;
    for slice = slices
        subplot(linesNum,slicesNum/2,subplotNum);
        imshowpair(B(:,:,slice), A(:,:,slice));
        title(['unregistered slice #' num2str(slice)]);
        subplotNum = subplotNum + 1;
    end
end