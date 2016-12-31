function showPointsOnPictures ( brain_fixed, brain_moving, fixedPoints, movingPoints )
%SHOWPOINTSONPICTURES plots the two pictures and the points selected for
%them
%   Displays a plot with two pictures and the points

    figure;
    subplot(1,2,1);
    imshow(brain_fixed);
    hold on
    axis xy equal
    plot(fixedPoints(:,1),fixedPoints(:,2), 'd', 'Color', 'red');
    for i = 1:size(fixedPoints,1)
        text(fixedPoints(i,1),fixedPoints(i,2), num2str(i));
    end
    title('Fixed brain');
    hold off

    subplot(1,2,2);
    imshow(brain_moving);
    hold on
    axis xy equal
    plot(movingPoints(:,1),movingPoints(:,2), 'd', 'Color', 'red');
    for i = 1:size(movingPoints,1)
        text(movingPoints(i,1),movingPoints(i,2), num2str(i));
    end
    title('Moved brain');
    hold off

end

