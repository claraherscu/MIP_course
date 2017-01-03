function showRegResultsWithOutliers(brain_fixed, brain_moving, tform, fixedPoints, movingPoints, rigidReg)

    % first, getting the transformed image and points
    transformedBrain = imwarp(brain_moving, tform, 'outputView', ...
            imref2d(size(brain_fixed)));
    N = size(fixedPoints,1);
    rigid_moving = [movingPoints ones(N,1)] * rigidReg;

    % plot comparison picture with outliers in blue and green
    figure;
    imshowpair(transformedBrain, brain_fixed);
    title('result of robust registration with outliers');
    hold on
    axis xy equal
    
    plot(fixedPoints(1:9,1),fixedPoints(1:9,2), 'd', 'Color', 'red');
    plot(fixedPoints(9:12,1),fixedPoints(9:12,2), 'd', 'Color', 'blue');
    for i = 1:size(fixedPoints,1)
        text(fixedPoints(i,1),fixedPoints(i,2), num2str(i));
    end

    plot(rigid_moving(1:9,1),rigid_moving(1:9,2), 'd', 'Color', 'yellow');
    plot(rigid_moving(9:12,1),rigid_moving(9:12,2), 'd', 'Color', 'green');
    for i = 1:size(movingPoints,1)
        text(rigid_moving(i,1),rigid_moving(i,2), num2str(i));
    end
    
    hold off

end