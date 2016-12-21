function [ lungsBand ] = getAreaAroundLungs( bodySeg, lungsSeg, sliceBB, sliceCC )
%GETAREAAROUNDLUNGS returns a 3D band of the area of the body around the
%lungs
%   From slice BB to slice CC, Extract the region confined by body and the 
%   convex hull of the lungs

lungsConv = getConv(lungsSeg);
bodyConv = getConv(bodySeg);
lungsBand = bodyConv - lungsConv;

% erasing everything out of wanted range BB:CC
lungsBand(:,:,1:sliceBB-1) = 0;
lungsBand(:,:,sliceCC:size(lungsBand(3))) = 0;

end

%%
function [ imgConv ] = getConv ( img )
% GETCONV takes a 3D binary image and returns the convex hull

imgConv = zeros(size(img));
for i = 1:size(img, 3)
    imgConv(:,:,i) = bwconvhull(img(:,:,i));
end

end
