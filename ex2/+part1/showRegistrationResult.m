function showRegistrationResult ( tform )

    % get the pictures
    load brain.mat;
    transformedBrain = imwarp(brain_moving, tform, 'outputView', ...
        imref2d(size(brain_fixed)));
    
    % show the pictures together
    figure;
    subplot(1,3,1);
    imshow(brain_fixed);
    title('Fixed brain');
    subplot(1,3,2);
    imshowpair(transformedBrain, brain_fixed);
    title('Comparison');
    subplot(1,3,3);
    imshow(transformedBrain);
    title('Transformation result');
end