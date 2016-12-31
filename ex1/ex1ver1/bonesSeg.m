dirPath = 'D:\Clara-University\third_year091216\MIP_course\ex1\partAFiles\';

% looping through the files
files = dir([dirPath '*CTce_ThAb.nii.gz']);
minX = zeros(numel(files));
figure;

for i = 1:numel(files)
    % loading niiStruct
    display(['loading: ' files(i).name]);
    niiStruct = load_untouch_nii_gzip([dirPath files(i).name]);
    
    % img is the volume matrix, getting the bones segmentation
    volume = niiStruct.img;
    [i_min, components] = findMinCC(volume);
    minX(i) = i_min;
    bones_seg = getBones(volume, i, i_min, components);
    
    % saving the segmentation image as new nifity file
    niiStruct.img = bones_seg;
    newFileName = strrep(files(i).name, 'CTce_ThAb', 'BoneSeg');
    save_untouch_nii_gzip(niiStruct, [dirPath newFileName]);
end
