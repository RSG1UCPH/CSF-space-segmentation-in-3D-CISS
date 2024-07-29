function save_nifti(data, filename, im_info)
% SAVE_NIFTI: Saves the data as a NIFTI file using the original image information.
%
% Inputs:
% - data: The data to be saved, converted to double to match original type.
% - filename: The name of the file to save the data.
% - im_info: The original NIFTI image information.

actualClass=class(data);

switch actualClass
    case 'uint8'
        correctDatatype = 'uint8';
        bytesPerVoxel = 1;
    case 'int16'
        correctDatatype = 'int16';
        bytesPerVoxel = 2;
    case 'int32'
        correctDatatype = 'int32';
        bytesPerVoxel = 4;
    case 'single'
        correctDatatype = 'single';
        bytesPerVoxel = 4;
    case 'double'
        correctDatatype = 'double';
        bytesPerVoxel = 8;
    otherwise
        error('Unsupported data type: %s', actualClass);
end


modified_info = im_info;
modified_info.Filename = filename;
modified_info.Datatype = actualClass;  % Ensure datatype is double
modified_info.DisplayIntensityRange=[0,1];
modified_info.Filesize=(numel(data) * bytesPerVoxel)+348; % Image size updated
modified_info.MultiplicativeScaling=1;
modified_info.BitsPerPixel=bytesPerVoxel*8;
modified_info.ImageSize=size(data);
modified_info.PixelDimensions=im_info.PixelDimensions(1:3);
niftiwrite(double(data), filename, modified_info);  % Convert data to double before saving
end