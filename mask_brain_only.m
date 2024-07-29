function BOX = mask_brain_only(image, plt)
% MASK_BRAIN_ONLY Masks the brain region in a 3D image.
% This function isolates the brain region in a given 3D image by generating
% a binary mask that excludes non-brain areas.
%
% INPUTS:
% image - 3D image data to be processed.
% plt - Flag indicating whether to display intermediate plots (1 for yes, 0 for no).
%
% OUTPUTS:
% BOX - Binary mask indicating the brain region.

%% Find the middle slice in the sagittal plane by averaging two central slices
midslice=image(:,:,round(size(image,3)/2))./2 + image(:,:,round(size(image,3)/2)-1)./2;  % find summary middle slice (in saggittal)

%% Display the middle slice if plotting is enabled
if plt==1
    imshow(flip(double(midslice),2), [0 ceil(max(midslice(:))*1/5)]); title('Middle slice');
end

%% Calculate the image intensity variance across columns in the middle slice
parfor iii=1:size(midslice,2)
    variance(iii)=var(double(midslice(:,iii)));
end; clear iii;

%% Calculate the image intensity variance across rows in the middle slice
parfor iii=1:size(midslice,1)
    variance2(iii)=var(double(midslice(iii,:)));
end; clear iii

%% COORDINATES IN SAGITTAL PLANE
% Determine the coordinates in the sagittal plane where the variance is
% nonzero
[x,y]=find(variance>0);
A=min(y); B=max(y)+5; x(y==B); clear x y variance; R=round(B/2);

[x,y]=find(variance2>0);
C=min(y)-3; D=max(y)+10; clear x y variance2 midslice;

%% COORDINATES IN CORONAL PLANE
% Determine the coordinates in the coronal plane by analyzing another middle slice
midslice2=squeeze(image(:,R,:)./2 + image(:,R+1,:)./2);

parfor iii=1:size(midslice2,2)
    variance3(iii)=var(double(midslice2(:,iii)));
end; clear iii

[x,y]=find(variance3>0);
E=min(y)-1; F=max(y)+1; clear x y variance3 midslice2;

%% FILL THE BOUNDING BOX
% Initialize the binary mask (BOX) and a secondary mask (BOX2) for the brain region
BOX=zeros(size(image,1),size(image,2),size(image,3));
BOX2=BOX;

% Define the main mask (BOX) and secondary mask (BOX2) based on calculated coordinates
BOX(C:D,A:B,E:F)=1;
BOX2(C:D,round(0.75*B):B+16,E:F)=1;

% Iterate through each slice to refine the masks and exclude non-brain areas
    for iiii=1:size(BOX,3)
        
        if plt==1
             % Display the current slice with the boundaries of BOX and BOX2
            imshow(double(image(:,:,iiii)),[0 ceil(max(image(:))*1/3)]); hold on;
            [Bd] = bwboundaries(BOX(:,:,iiii));
            [Bd2]=bwboundaries(BOX2(:,:,iiii));
            for kkk=1:length(Bd)
                BD=Bd{kkk};
                plot(BD(:,2), BD(:,1),'r', 'linewidth', 2);
            end; clear kkk Bd BD
            
            for kkk=1:length(Bd2)
                BD2=Bd2{kkk};
                plot(BD2(:,2), BD2(:,1),'g*', 'linewidth', 2);
            end; clear kkk Bd2 BD2
        end
        
        temp_im=image(:,:,iiii);
        temp_Box2=BOX2(:,:,iiii);
        
        temp_Box2(temp_im>0)=0;
        
        % Dilate the mask to fill gaps and smooth boundaries
        se = strel('disk',11);
        temp_Box2 = imdilate(temp_Box2,se); clear se;

        
        if plt==1
            % Display the refined mask boundaries
            [Bd3]=bwboundaries(temp_Box2);
            for kkk=1:length(Bd3)
                BD3=Bd3{kkk};
                plot(BD3(:,2), BD3(:,1),'m-', 'linewidth', 1);
            end; clear kkk Bd3 BD3;
        end
        
        % Refine the mask further by selecting regions based on shape properties
        s=regionprops(~temp_Box2,'Circularity','Eccentricity','Perimeter','PixelList');
        
        for ddd=1:length(s)
            if  (s(ddd).Eccentricity>=0.5 | s(ddd).Circularity>=0.5) & s(ddd).Perimeter<0.00005*length(image(image>0)); % 350     %perimeter adapted for the high resolution images
                temp_Box2(s(ddd).PixelList(:,2),s(ddd).PixelList(:,1))=1;
            end
        end; clear s;
        
        % Erode and fill holes in the refined mask
        se = strel('disk',11);                      %kernel size used for high-resolution images, can be changed
        temp_Box2 = imerode(temp_Box2,se); clear se
        temp_Box2=imfill(temp_Box2,'holes');
        
        
        if plt==1
            % Display the final refined mask boundaries
            [Bd4]=bwboundaries(temp_Box2);
            for kkk=1:length(Bd4)
                BD4=Bd4{kkk};
                plot(BD4(:,2), BD4(:,1),'b.', 'linewidth', 1);
            end; clear kkk Bd4 BD4 s; pause(0.005); hold off;
            %imshow(~temp_Box2,[0 1]);pause(0.3);
        end

        % Update the secondary mask for the current slice
        BOX2(:,:,iiii)=~temp_Box2;
        
    end; clear iiii

    % Combine the main mask and the refined secondary mask
    BOX=BOX.*BOX2;
    
end

