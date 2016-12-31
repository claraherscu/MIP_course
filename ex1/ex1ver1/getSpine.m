function [ spineSeg ] = getSpine( volume, aortaSeg, bodySeg, CtType )
%GETSPINE get the segmentation of the spine based on the segmentation of
%the aorta
%   the aorta gives us a good estimator for the location (in the x,y axes)
%   of the spine. we can "crop" the volume to concentrate on the correct
%   part of the volume and look for the spine

spineSeg=zeros(size(bodySeg));
for i=1:size(bodySeg,3)
    [x1, y1] = find(aortaSeg(:,:,i)==1,1,'first');
    [x2, y2] = find(aortaSeg(:,:,i)==1,1,'last');
    if (strcmp(CtType,'ABTH') == 1)
        spineSeg(x1-60:x2+60,y2+10:y2+125,i)=1;
    else
        spineSeg(x1-60:x2+60,y1-125:y1-10,i)=1;
    end
end
spineSeg = and(spineSeg,bodySeg);
spineSeg = spineSeg & bodySeg;

end