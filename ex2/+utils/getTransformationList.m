function [ tforms ] = getTransformationList( )
    normalize = @(x)x./norm(x);
    tforms(1).sourceName = 'T1';
    tforms(1).datasetName = 'T1';
    tforms(1).translation_mm = [ 0 0 0]; 
    tforms(1).rotation_deg = 0;
    tforms(1).rotationAxis = [0 0 1];
    
    tforms(2).sourceName = 'T2';
    tforms(2).datasetName = 'T2';
    tforms(2).translation_mm = [ 0 0 0]; 
    tforms(2).rotation_deg = 0;
    tforms(2).rotationAxis = [0 0 1];
    
    tforms(3).sourceName = 'T1';
    tforms(3).datasetName = 'T1_shift_y';
    tforms(3).translation_mm = [ 0 -7.93 0]; 
    tforms(3).rotation_deg = 0;
    tforms(3).rotationAxis = [0 0 1];
    
    tforms(4).sourceName = 'T2';
    tforms(4).datasetName = 'T2_rot_z';
    tforms(4).translation_mm = [ 0 0 0]; 
    tforms(4).rotation_deg = -24;
    tforms(4).rotationAxis = [0 0 1];
    
    tforms(5).sourceName = 'T1';
    tforms(5).datasetName = 'T1_rot_z';
    tforms(5).translation_mm = [ 0 0 0]; 
    tforms(5).rotation_deg = 33;
    tforms(5).rotationAxis = [0 0 1];
    
    tforms(6).sourceName = 'T2';
    tforms(6).datasetName = 'T2_rot_n';
    tforms(6).translation_mm = [ 0 0 0]; 
    tforms(6).rotation_deg = -19;
    tforms(6).rotationAxis = normalize([1 1 3]);
end

