function SegmentBones( ctFileName, AortaFileName, CtType , outputFileName )
%SEGMENTBONES a function for segmenting the bones
%   1. segmenting body
%   2. segmenting lungs
%   3. getting band around lungs
%   4. getting the spine ROI using given aorta segmentation
%   5. using multiple seeded region growing to get a segmentation of the
%   bones.

    % loading niiStruct
    display(['loading: ' ctFileName]);
    niiStruct = load_untouch_nii_gzip(ctFileName);
    
    % img is the volume matrix, getting the body segmentation
    volume = niiStruct.img;
    slicesNum = size(volume, 3);
    display(['#slices: ' num2str(slicesNum)]);
    bodySeg = getBody(volume);
    
%     % saving the segmentation image as new nifity file
%     niiStruct.img = bodySeg;
%     newFileName = strrep(ctFileName, '_original', '_BodySeg');
%     save_untouch_nii_gzip(niiStruct, newFileName);
    
    % segmenting lungs
    [lungsSeg, slices] = getLungs (bodySeg, CtType);
    
%     % saving the segmentation image as new nifity file and displaying BB&CC
%     niiStruct.img = lungsSeg;
%     newFileName = strrep(ctFileName, '_original', '_LungsSeg');
%     save_untouch_nii_gzip(niiStruct, newFileName);
    display(['BB = ', num2str(slices(1)), ' CC = ', num2str(slices(2))]);
    
    % getting 3D band around lungs from BB to CC
    display('getting 3D band around lungs from BB to CC');
    lungsBand = getAreaAroundLungs(bodySeg, lungsSeg, slices(1), slices(2));
    
%     % saving the segmentation image as new nifity file
%     niiStruct.img = lungsBand;
%     newFileName = strrep(ctFileName, '_original', '_LungsBand');
%     save_untouch_nii_gzip(niiStruct, newFileName);
   
    % finding spine using aorta segmentation
    display(['loading: ' AortaFileName]);
    niiStructAorta = load_untouch_nii_gzip(AortaFileName);
    aortaSeg = niiStructAorta.img;
    
    spineROI = getSpine(volume, aortaSeg, bodySeg, CtType);
%     % saving the segmentation image as new nifity file
%     niiStructAorta.img = spineROI;
%     newFileName = strrep(AortaFileName, '_Aorta', '_SpineROI');
%     save_untouch_nii_gzip(niiStructAorta, newFileName);
    
    spineAndChestROI = spineROI | lungsBand;
%     % saving the segmentation image as new nifity file
%     niiStructAorta.img = spineAndChestROI;
%     newFileName = strrep(AortaFileName, '_Aorta', '_entireROI');
%     save_untouch_nii_gzip(niiStructAorta, newFileName);
    
    spine_seeds = getSeeds(volume, spineROI);
    % saving the segmentation image as new nifity file
    niiStructAorta.img = spine_seeds;
    newFileName = strrep(AortaFileName, '_Aorta', '_spine_seeds');
    save_untouch_nii_gzip(niiStructAorta, newFileName);
    
    % getting a more focused view of the lung band to get the seeds
    band = isolate_band_for_seeds(bodySeg, lungsBand); 
    if(sum(band(:)) == 0)
        for i = 1:size(bodySeg, 3) - 6
            lungsBand(:,:,i) = 0;
        end
        band = lungsBand;
    end
    band_seeds = getSeeds(volume, band);
    niiStructAorta.img = band_seeds;
    newFileName = strrep(AortaFileName, 'Aorta', 'band_seeds');
    save_untouch_nii_gzip(niiStructAorta, newFileName);
    tic;
    % segmenting spine using Region Growing function  
    display('starting spine segmentation using region growing');
    
    spine_region_growing = regionGrowing(spine_seeds ,volume);
    niiStructAorta.img = spine_region_growing;
    newFileName = strrep(AortaFileName, 'Aorta', 'spine_region_growing');
    save_untouch_nii_gzip(niiStructAorta, newFileName);   
    
    display('finished spine segmentation, starting ribs segmentation');
    
    % segmenting ribs using region growing function
    ribs_region_growing = ribsRegionGrowing(band_seeds ,volume, ...
        spine_region_growing);
    toc;
    niiStructAorta.img = ribs_region_growing;
    newFileName = strrep(AortaFileName, 'Aorta', 'ribs_region_growing');
    save_untouch_nii_gzip(niiStructAorta, newFileName);
    
    display('finished ribs segmentation');
    
    % combining results of regionGrowing in the ribs and spine
    entire_region_growing = ribs_region_growing|spine_region_growing;
    niiStructAorta.img = entire_region_growing;
    save_untouch_nii_gzip(niiStructAorta, outputFileName);
    
    display('============ done with this file ============');

end
