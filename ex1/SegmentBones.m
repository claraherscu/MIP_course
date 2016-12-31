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
    
    % segmenting lungs
    [lungsSeg, slices] = getLungs (bodySeg, CtType);
    display(['BB = ', num2str(slices(1)), ' CC = ', num2str(slices(2))]);
    
    % getting 3D band around lungs from BB to CC
    display('getting 3D band around lungs from BB to CC');
    lungsBand = getAreaAroundLungs(bodySeg, lungsSeg, slices(1), slices(2));
   
    % finding spine using aorta segmentation
    display(['loading: ' AortaFileName]);
    niiStructAorta = load_untouch_nii_gzip(AortaFileName);
    aortaSeg = niiStructAorta.img;
    
    spineROI = getSpine(volume, aortaSeg, bodySeg, CtType);
    spineAndChestROI = spineROI | lungsBand;
    spine_seeds = getSeeds(volume, spineROI);
    
    % getting a more focused view of the lung band to get the seeds
    band = isolate_band_for_seeds(bodySeg, lungsBand); 
    if(sum(band(:)) == 0)
        for i = 1:size(bodySeg, 3) - 6
            lungsBand(:,:,i) = 0;
        end
        band = lungsBand;
    end
    band_seeds = getSeeds(volume, band);
 
    % segmenting spine using Region Growing function  
    display('starting spine segmentation using region growing');
    
    spine_region_growing = regionGrowing(spine_seeds ,volume, CtType);
    % segmenting ribs using region growing function
    ribs_region_growing = ribsRegionGrowing(band_seeds ,volume, ...
        spine_region_growing);
    display('finished segmentation');
    
    % combining results of regionGrowing in the ribs and spine
    entire_region_growing = ribs_region_growing|spine_region_growing;
    niiStructAorta.img = entire_region_growing;
    save_untouch_nii_gzip(niiStructAorta, outputFileName);
    
    display('============ done with this file ============');

end
