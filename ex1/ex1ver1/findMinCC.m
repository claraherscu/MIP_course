function [ i_min, components ] = findMinCC( volume )
%FINDMINCC a function for finding the index of the minimum number of
% connected components
%   iterates through values from 150 to 500 to find the best threshold.

i_max = 1300;

% searching for i_min
display('finding i_min');
X = 150:5:500;
components = zeros(1,71);

j = 1;
for i = 1:size(X,2)
   curr_min = X(i);
   imgSeg = volume < i_max & volume > curr_min;
   
   % finding number of connected components: connectivity of 26
   CC = bwconncomp(imgSeg, 26);
   components(j) = CC.NumObjects;
   j = j + 1;
   
%    display(['for i = ', num2str(curr_min), ' got #components: ', num2str(components(j-1))]);
end

% finding i_min
components = -1 * components;
[peaks, locations] = findpeaks(components);
peaks = -1 * peaks;
[num_comp, minIdx] = min(peaks(1:4));
i_min = X(locations(minIdx));
components = -1 * components;
display(['i_min = ', num2str(i_min),'. #Components ', num2str(num_comp)]);

end

