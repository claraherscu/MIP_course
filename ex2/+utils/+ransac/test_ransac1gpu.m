function test_ransac1gpu
N = 10000;
M = 3;
E = 1e-3;
X = rand(M,M,N);

gpuX = reshape(gpuArray(X),M*M,N).';
% [s,v,d]=myfun(gpuX(1,1),gpuX(1,2),gpuX(1,3),gpuX(1,4),gpuX(1,5),gpuX(1,6),gpuX(1,7),gpuX(1,8),gpuX(1,9))
[S,V,D] = arrayfun(@myfun, gpuX(:,1),gpuX(:,2),gpuX(:,3),gpuX(:,4),gpuX(:,5),gpuX(:,6),gpuX(:,7),gpuX(:,8),gpuX(:,9));

% 
% coef.minPtNum = 4;
% coef.iterNum = 1e3;
% coef.thDist = 4;
% coef.thInlrRatio = .1;
% 
% A_=ransac1gpu(X,Y,coef,@solveHomo,@calcDist);
% 
% A_-A

end

function [v,s,d] = myfun(a11,a21,a31,a12,a22,a32,a13,a23,a33)
    v=1; d=1; s=1;
    [vv,ss,dd] = svd([a11 a12 a13; a21 a22 a23; a31 a32 a33]);
end