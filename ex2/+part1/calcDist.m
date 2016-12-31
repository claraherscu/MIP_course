function d_pixel = calcDist(fixedPoints, movingPoints, rigidReg)
% CALCDIST calculate the Root Mean Square Error of the registration

    N=length(fixedPoints);
    rigid_moving = [movingPoints ones(N,1)] * rigidReg;
    d_pixel = sqrt((rigid_moving(:,1)-fixedPoints(:,1)).^2 + ...
        (rigid_moving(:,2)-fixedPoints(:,2)).^2);
    rmse = sqrt( sum(d_pixel.^2) / numel(d_pixel) )
end