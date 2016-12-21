%files = dir('D:\Github\PhD-Research\Targil_1_partB_data\*CT.nii.gz');
files = dir('D:\Github\PhD-Research\Targil_1_partB_data\tmp_Arterial_phase_RTD_A4NN_CT.nii.gz');
%niistruct=load_untouch_nii_gzip('D:\Github\PhD-Research\Targil_1_partB_data\ARTERIAL_PHASE_A1EL.nii.gz');
%aorta=load_untouch_nii_gzip('D:\Github\PhD-Research\Targil_1_partB_data\ARTERIAL_PHASE_A1EL_Aorta.nii.gz');
for file = files'
    path = 'D:\Github\PhD-Research\Targil_1_partB_data\';
    display(file.name)
    niistruct=load_untouch_nii_gzip([path file.name]);
    original_image = niistruct.img;
    aorta_file_name = strrep(file.name, 'CT', 'Aorta');
    aorta=load_untouch_nii_gzip([path aorta_file_name]);
    body_seg = isolate_body(niistruct.img);
    niistruct.img = body_seg;
    path = 'D:\Github\PhD-Research\Targil_1_partB_solution\';
    body_file_name = strrep(aorta_file_name, 'Aorta', 'Body');
    save_untouch_nii_gzip(niistruct,[path body_file_name])
    [lung_seg, slices]= isolate_lungs(body_seg);
    niistruct.img = lung_seg;
    lungs_file_name = strrep(aorta_file_name, 'Aorta', 'Lung');
    save_untouch_nii_gzip(niistruct,[path lungs_file_name])
    band_seg = isolate_band(body_seg, lung_seg, slices);
    niistruct.img = band_seg;
    band_file_name = strrep(aorta_file_name, 'Aorta', 'band');
    save_untouch_nii_gzip(niistruct,[path band_file_name])
    spine_seg = isolate_spine(body_seg, aorta.img);
    niistruct.img = spine_seg;
    spine_file_name = strrep(aorta_file_name, 'Aorta', 'spine');
    save_untouch_nii_gzip(niistruct,[path spine_file_name])
    final_segmentation = or(spine_seg, band_seg);
    niistruct.img = final_segmentation;
    final_file_name = strrep(aorta_file_name, 'Aorta', 'final');
    save_untouch_nii_gzip(niistruct,[path final_file_name])
    
    %Part C 
    %Find seeds
    spine_seeds = find_seeds(spine_seg,original_image);
    niistruct.img = spine_seeds;
    
    final_file_name = strrep(aorta_file_name, 'Aorta', 'seeds');
    save_untouch_nii_gzip(niistruct,[path final_file_name])
    
    
    %Region Growing function  
    temp = zeros(size(original_image));
    temp(245,220,11)=1;
    
    region_growing = rgms_iterative(spine_seeds ,original_image);
    niistruct.img = region_growing;
    
    final_file_name = strrep(aorta_file_name, 'Aorta', 'region_growing');
    save_untouch_nii_gzip(niistruct,[path final_file_name])    
    
    
end