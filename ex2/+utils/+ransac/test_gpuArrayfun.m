function test_gpuArrayfun
N = 1e5;
M = 3;
A = rand(M,M,N);

% calculate the det of N MxM matrices
d_cpu = nan(N,1);
tic
for i=1:N
    d_cpu(i) = det(A(:,:,i));
end
cpuTime = toc

Agpu = gpuArray(reshape(A,[M*M,N]));
command = ['d_gpu=arrayfun(@vararginDet,']
for i=1:M*M-1
    command=[command 'Agpu(' num2str(i) ',:),'];
end
command=[command 'Agpu(' num2str(M*M) ',:));'];
eval(command);
end

function d=vararginDet(varargin)
    m=sqrt(nargin);
    d=det(reshape(cell2mat(varargin),m,m));
end
