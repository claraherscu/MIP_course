function [ BoneSeg ] = MaxFlowCoarseBoneSeg( StripAroundLungs )
% function was given by course staff 

ur = double(StripAroundLungs);
umax = max(max(max(ur)));
umin = min(min(min(ur)));
ur = (ur - umin)/(umax-umin);
[rows, cols,heights] = size(ur);
varParas = [rows; cols; heights; 200; 5e-4; 0.25 ; 0.11];
penalty = 0.5*ones(rows, cols, heights);
postiveUr = ur(ur>0);
p1 = mean(postiveUr) ;
p2 = quantile(postiveUr,0.99) ;
%
ulab(1) = p1;
ulab(2) = p2;
% build up the priori L_2 data terms
fCs = abs(ur - ulab(1));
fCt = abs(ur - ulab(2));
[uu, erriter,num,tt] = CMF3D_mex(single(penalty), single(fCs), single(fCt),
single(varParas));
BoneSeg = StripAroundLungs;
BoneSeg(uu<0.99)=0;

end

