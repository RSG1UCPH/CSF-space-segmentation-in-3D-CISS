function CSF_volumetry(pathname, filename, plt, mfilt, params);
%% This automatic pipeline for fully non-invasive cerebral-spinal fluid volumetry introduces
%% an analytical algorithm for objective and SNR-independent (within good range of SNRs) delineation
%% of highly T2-weighted CSF space regions form 3D-CISS images of the mouse brain.
%%
%% INPUT:
%1)medf = 0/1;  % Median filter flag
%2) plt - plotting flag - plot output of every step 1-yes, 0-no
%%
%%By dr. eng. Ryszard S. Gomolka
% Assitant Professor
% Center for Translational Neuromedicine
% University of Copenhagen, May 2024

% Legend: Version 3.1; Copyrights RSGomolka CTN.
%
%% Usage, modifiactions or sharing requires citing the method's original source!
%
% Example usage:CSF_volumetry([], [], 1,1,struct('alpha', 0.02, 'alpha2', 0.025, 'percentile', 97.5));

%% Check the number of input arguments and set defaults
if nargin < 1
    plt = 0;  % Default plotting to no
end
if nargin < 2
    mfilt = 0;  % Default median filtering to no
end
if nargin < 3
    params.alpha = 0.02;
    params.alpha2 = 0.025;
    params.percentile = 97.5;
end

%% Prompt user to select a NIFTI file if not input is provided
if isempty(filename)==1 || isempty(pathname)==1
    [filename, pathname] = uigetfile('*.nii', 'Select a NIFTI file');
end
niftiFile = fullfile(pathname, filename);
%% Load the image data from the selected file
try
    if endsWith(niftiFile, '.nii.gz')
        gunzip(niftiFile);
        unzippedFile = strrep(niftiFile, '.nii.gz', '.nii');
        image = double(niftiread(unzippedFile));  % Use double to ensure it matches the desired data type
        im_info = niftiinfo(unzippedFile);
        delete(unzippedFile);  % Clean up the unzipped file
        filename=filename(1:end-7);
    else
        image = double(niftiread(niftiFile));  % Use double to ensure it matches the desired data type
        im_info = niftiinfo(niftiFile);
        filename=filename(1:end-4);
    end
catch
    error('Error reading NIFTI file. Please check the file format.');
end

tic;

%% Mask the brain region
BOX = mask_brain_only(image, plt);

%% Applying bounding box for the brain parenchyma
new_image = image.* BOX; clear BOX image;

%% Calculate image SNR-dependent stats
[P,V,xp]=SNRstats(new_image);

%% Intensify CSF space regions
[mask] = intensify_CSF(new_image,P);

%% OPTIONAL - show the intensified CSF space image
if plt==1
    for zzz=1:size(mask,3)
        imshow(mask(:,:,zzz), [0 1]); pause(0.1);
        title('Intensified CSF space mask')
    end; clear zzz
end

%% Optional median filtering and saving initial CSF mask
if mfilt==1
    mask=medfilt3(mask, [3 3 3]);
end

if plt==1
    for zzz=1:size(mask,3)
        imshow(mask(:,:,zzz), [0 1]); pause(0.1);
    end; clear zzz
end

% save initial mask after intensifying CSF voxels and optionally median filtering
save_nifti(double(mask), [pathname, filename, '_initial_CSF_mask.nii'], im_info);

%% Reconsider boundaries of the initially delineated CSF space
mask2=grow_regions(mask,new_image,plt,xp,params); clear mask;

% save intermediate mask after region growing in sagittal plane
save_nifti(double(mask2), [pathname, filename, '_mask_saggital_reg_grow.nii'], im_info);

%% Reconsider boundaries of the delineated CSF space, in coronal plane
mask3=permute(mask2,[2,3,1]); clear mask2;
new_image2=permute(new_image,[2,3,1]);

mask4=grow_regions2(mask3,new_image2,plt,xp,mfilt,params); clear mask3

%% Reconsider boundaries of the delineated CSF space, in axial plane
new_image3=permute(new_image2,[3,2,1]);clear new_image2;
mask5=permute(mask4,[3,2,1]); clear mask4;

mask6=grow_regions2(mask5,new_image3,plt,xp,mfilt,params); clear mask5 ;

%% Bring back the mask to the original 3D image conformation
mask7=permute(mask6,[1,3,2]); clear mask6 new_image3

%% Optional - apply median filter if needed, and save the final results
if mfilt == 1
    mask7 = medfilt3(mask7, [3 3 3]);
    mask7(mask7<1)=0;
    % save final mask mask after region growing in sagittal plane
    save_nifti(double(mask7), [pathname, filename, '_CSF_mask_medfilt_final.nii'], im_info);
else
    mask7(mask7<1)=0;
    save_nifti(double(mask7), [pathname, filename, '_CSF_mask_final.nii'], im_info);
end
clear mask7 new_image3

%% Finalize
disp(['Processing completed. Elapsed time: ', num2str(toc), ' seconds.']);
end