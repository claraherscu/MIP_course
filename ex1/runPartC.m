% a script for running SegmentBones and evaluateSegmentation

clear;
clc;
dirPath = 'D:\Clara-University\third_year091216\MIP_course\ex1\partBFiles\';

% looping through the files
original_files = dir([dirPath '*_original.nii.gz']);
aorta_files = dir([dirPath '*_Aorta.nii.gz']);
% l1_files = dir([dirPath '*_29193_*.nii.gz']);

for i = 5%1:numel(original_files)
    originalFileName = [dirPath original_files(i).name];
    aortaFileName = [dirPath aorta_files(i).name];
    outputFileName = [dirPath strrep(original_files(i).name,...
        '_original', '_regionGrowing')];
    SegmentBones(originalFileName, aortaFileName, 'ABTH' , outputFileName);
%     groundTruthFilename = [dirPath l1_files(i).name];
%     [VD, VDO] = evaluateSegmentaion(outputFileName, groundTruthFilename);
%     display(VDO);
end