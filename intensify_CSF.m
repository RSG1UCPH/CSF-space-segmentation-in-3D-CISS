function [new_image] = intensify_CSF(image, P)
% INTENSIFY_CSF Enhances CSF regions in a 3D image by adjusting intensities and thresholding.
% This function processes a 3D image to enhance cerebrospinal fluid (CSF) regions
% to depict their ‘seed points’ for subsequent automatic segmentation,
% by normalizing and thresholding the 3image intensities.
%
% INPUTS:
% image - 3D image data to be processed.
% P - Percentile value used for thresholding the image intensities.
%
% OUTPUTS:
% new_image - Binary image highlighting the CSF regions.

%% Flatten the image into a vector
vect=image(:);

%% Normalize the image by subtracting 1.33 times the standard deviation of non-zero intensities
% and then dividing by the standard deviation of non-zero intensities
new_image=(image-(1.33)*std(vect(vect>0)))./std(vect(vect>0)); clear vect image;

%% Calculate the Pth percentile of the non-zero intensities in the normalized image
Px=round(prctile(new_image(new_image>0),P));

%% Threshold the image at the Pth percentile, setting all intensities below Px to 0
new_image(new_image<=Px)=0;clear P xp Px;

%% Set all remaining non-zero intensities to 1, creating a binary image
new_image(new_image>0)=1;

end
