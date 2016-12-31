function [ scan ] = getScan( scanName )
    h5filename = [utils.getDataPath() scanName '.h5'];
    if ~exist(h5filename,'file')
        error(['Could not find ' h5filename]);
    end
    att = h5info(h5filename);
    fieldNames = {att.Datasets.Name};
    scan = struct();
    for f=fieldNames
        scan.(f{1}) = h5read(h5filename,['/' f{1}]');
    end
    scan.img = single(scan.img);
    scan.ref = utils.getRef(size(scan.img),scan.voxelDimension_mm);
end

