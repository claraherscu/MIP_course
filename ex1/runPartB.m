clear;
clc;
dirPath = 'D:\Clara-University\third_year091216\MIP_course\ex1\partBFiles\';

% looping through the files
original_files = dir([dirPath '*_original.nii.gz']);
aorta_files = dir([dirPath '*_Aorta.nii.gz']);

for i = 1:numel(original_files)
    % loading niiStruct
    display(['loading: ' original_files(i).name]);
    niiStruct = load_untouch_nii_gzip([dirPath original_files(i).name]);
    
    % img is the volume matrix, getting the body segmentation
    volume = niiStruct.img;
    slicesNum = size(volume, 3);
    display(['#slices: ' num2str(slicesNum)]);
    bodySeg = getBody(volume);
    
%     % saving the segmentation image as new nifity file
%     niiStruct.img = body_seg;
%     newFileName = strrep(files(i).name, '_original', '_BodySeg');
%     save_untouch_nii_gzip(niiStruct, [dirPath newFileName]);
    
    % segmenting lungs
    CT_type = 'ABTH';
    if slicesNum < 300
        CT_type = 'AB';
    end
    [lungsSeg, slices] = getLungs (bodySeg, CT_type);
    
%     % saving the segmentation image as new nifity file and displaying BB&CC
%     niiStruct.img = lungsSeg;
%     newFileName = strrep(files(i).name, '_original', '_LungsSeg');
%     save_untouch_nii_gzip(niiStruct, [dirPath newFileName]);
%     display(['BB = ', num2str(slices(1)), ' CC = ', num2str(slices(2))]);
    
    % getting 3D band around lungs from BB to CC
    display('getting 3D band around lungs from BB to CC');
    lungsBand = getAreaAroundLungs(bodySeg, lungsSeg, slices(1), slices(2));
    
%     % saving the segmentation image as new nifity file
%     niiStruct.img = lungsBand;
%     newFileName = strrep(files(i).name, '_original', '_LungsBand');
%     save_untouch_nii_gzip(niiStruct, [dirPath newFileName]);
   
    % finding spine using aorta segmentation
    display(['loading: ' aorta_files(i).name]);
    niiStructAorta = load_untouch_nii_gzip([dirPath aorta_files(i).name]);
    aortaSeg = niiStructAorta.img;
    
    spineSeg = getSpine(volume, aortaSeg, bodySeg);
%     % saving the segmentation image as new nifity file
%     niiStructAorta.img = spineSeg;
%     newFileName = strrep(aorta_files(i).name, '_Aorta', '_SpineROI');
%     save_untouch_nii_gzip(niiStructAorta, [dirPath newFileName]);
    
    spineAndChestROI = spineSeg | lungsBand;
%     % saving the segmentation image as new nifity file
%     niiStructAorta.img = spineAndChestROI;
%     newFileName = strrep(aorta_files(i).name, '_Aorta', '_entireROI');
%     save_untouch_nii_gzip(niiStructAorta, [dirPath newFileName]);
    

    seeds = getSeeds(volume, spineSeg);
    % saving the segmentation image as new nifity file
    niiStructAorta.img = seeds;
    newFileName = strrep(aorta_files(i).name, '_Aorta', '_spine_seeds');
    save_untouch_nii_gzip(niiStructAorta, [dirPath newFileName]);
    
    band_seeds = isolate_band_seeds(bodySeg, lungsBand); 
    niiStructAorta.img = band_seeds;
    
    final_file_name = strrep(aorta_files(i).name, 'Aorta', 'band_seeds');
    save_untouch_nii_gzip(niiStructAorta,[dirPath final_file_name])
    
    %Spine Region Growing function  
    spine_region_growing = regionGrowing(spine_seeds ,volume);
    niistruct.img = spine_region_growing;
    
    final_file_name = strrep(aorta_files(i).name, 'Aorta', 'spine_region_growing');
    save_untouch_nii_gzip(niiStructAorta,[dirPath final_file_name])    
    
    %Ribs region growing
    ribs_region_growing = ribsRegionGrowing(band_seeds ,volume);
    niistruct.img = ribs_region_growing;
    
    final_file_name = strrep(aorta_files(i).name, 'Aorta', 'ribs_region_growing');
    save_untouch_nii_gzip(niiStructAorta,[dirPath final_file_name]) 
    
end