function mask2=grow_regions2(mask, new_image, plt, xp, mfilt, params)
% GROW_REGIONS: Grows regions in the image based on intensity and connectivity
%
% Inputs:
% - mask: The initial binary mask
% - new_image: The original image
% - plt: Plotting flag (1 to enable plotting, 0 to disable)
% - xp: Adaptive threshold parameter
% - mfilt: 2D median filtering
% - params: Structure containing alpha, alpha2, and percentile threshold parameters.
%
% Outputs:
% - mask2: The refined binary mask after region growing.

disp('Region growing running...');

vect = new_image(new_image > 0);
P = prctile(vect, params.percentile - 2 - xp); %match 95.5% percentile -xp
clear vect;

mask2 = zeros(size(mask));

alfa = params.alpha;  % threshold for contrast inclusion
alfa2 = params.alpha2;  % threshold for contrast exclusion

% Process each slice (excluding the last one)
for mmm=1:size(new_image,3)-1
    im_mid=new_image(:,:,mmm);  % Current slice of the image
    sl_mid=mask(:,:,mmm);  % Current slice of the mask

    % Create zero-padded versions of the current slice
    sl_mid2=zeros(size(sl_mid,1)+6,size(sl_mid,2)+6);
    im_mid2=sl_mid2;

    sl_mid2(4:end-3,4:end-3)=sl_mid; clear sl_mid; sl_mid=sl_mid2; clear sl_mid2;
    im_mid2(4:end-3,4:end-3)=im_mid; clear im_mid; im_mid=im_mid2; clear im_mid2;

    % If the slice contains any regions
    if sum(sl_mid(:)) > 0
        [B, ~] = bwboundaries(sl_mid);% Detect boundaries of the regions

        %% INCLUSION LEFT SIDE

        for zzz=1:length(B)                          %For all the regions initially segmented

            BD1 = B{zzz};

            for k=1:length(BD1)

                for vvv=1:3

                    %% INCLUSION LEFT SIDE

                    % horizontal only current slice right side
                    if im_mid(BD1(k,1), BD1(k,2))>=P(1) & abs((mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) - mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2)-vvv)))/(mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) + mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2)-vvv))))<=alfa
                        sl_mid(BD1(k,1), BD1(k,2)-vvv)=1;
                    end
                    % horizontal only current slice left side
                    if im_mid(BD1(k,1), BD1(k,2))>=P(1) & abs((mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) - mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2)+vvv)))/(mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) + mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2)+vvv))))<=alfa
                        sl_mid(BD1(k,1), BD1(k,2)+vvv)=1;
                    end
                    %vertical only current slice down side
                    if im_mid(BD1(k,1), BD1(k,2))>=P(1) & abs((mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) - mean(im_mid(BD1(k,1)-vvv, BD1(k,2):BD1(k,2))))/(mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) + mean(im_mid(BD1(k,1)-vvv, BD1(k,2):BD1(k,2)))))<=alfa
                        sl_mid(BD1(k,1)-vvv, BD1(k,2))=1;
                    end
                    %vertical only current slice up side
                    if im_mid(BD1(k,1), BD1(k,2))>=P(1) & abs((mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) - mean(im_mid(BD1(k,1)+vvv, BD1(k,2):BD1(k,2))))/(mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) + mean(im_mid(BD1(k,1)+vvv, BD1(k,2):BD1(k,2)))))<=alfa
                        sl_mid(BD1(k,1)+vvv, BD1(k,2))=1;
                    end
                    %diagonal only current slice up side
                    if im_mid(BD1(k,1), BD1(k,2))>=P(1) & abs((mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) - mean(im_mid(BD1(k,1)+vvv, BD1(k,2):BD1(k,2)+vvv)))/(mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) + mean(im_mid(BD1(k,1)+vvv, BD1(k,2):BD1(k,2)+vvv))))<=alfa
                        sl_mid(BD1(k,1)+vvv, BD1(k,2)+vvv)=1;
                    end
                    %diagonal only current slice down side
                    if im_mid(BD1(k,1), BD1(k,2))>=P(1) & abs((mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) - mean(im_mid(BD1(k,1)-vvv, BD1(k,2):BD1(k,2)-vvv)))/(mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) + mean(im_mid(BD1(k,1)-vvv, BD1(k,2):BD1(k,2)-vvv))))<=alfa
                        sl_mid(BD1(k,1)-vvv, BD1(k,2)-vvv)=1;
                    end
                    %diagonal only current slice crossup side
                    if im_mid(BD1(k,1), BD1(k,2))>=P(1) & abs((mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) - mean(im_mid(BD1(k,1)+vvv, BD1(k,2):BD1(k,2)-vvv)))/(mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) + mean(im_mid(BD1(k,1)+vvv, BD1(k,2):BD1(k,2)-vvv))))<=alfa
                        sl_mid(BD1(k,1)+vvv, BD1(k,2)-vvv)=1;
                    end
                    %diagonal only current slice crossdown side
                    if im_mid(BD1(k,1), BD1(k,2))>=P(1) & abs((mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) - mean(im_mid(BD1(k,1)-vvv, BD1(k,2):BD1(k,2)+vvv)))/(mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) + mean(im_mid(BD1(k,1)-vvv, BD1(k,2):BD1(k,2)+vvv))))<=alfa
                        sl_mid(BD1(k,1)-vvv, BD1(k,2)+vvv)=1;
                    end
                end; clear vvv;
            end; clear k BD1;
        end;clear zzz B L s;


       [B, ~]= bwboundaries(sl_mid);

        if plt==1
            imshow(im_mid, [min(im_mid(:)) max(im_mid(:))]); hold on;

            for kkk=1:length(B)
                BD=B{kkk};
                plot(BD(:,2), BD(:,1),'r', 'linewidth', 2);clear BD;
                text(0,10,'Dilated','Color','r');
                text(round(size(sl_mid,1)/2),10,'Eroded','Color','g')
            end
            clear kkk;pause(0.1);
        end

        %% EXCLUSION LEFT SIDE

        for zzz=1:length(B)                          %For all the regions initially segmented

            BD1 = B{zzz};

            for k=1:length(BD1)
                if ((BD1(k,1) & BD1(k,2))~= 1 && (BD1(k,1) & BD1(k,2))~= 2)
                    for vvv=1:3
                        % horizontal only current slice right side  im_mid(BD1(k,1), BD1(k,2)-vvv)>=P(1) &
                        if im_mid(BD1(k,1), BD1(k,2)-vvv)<P(1) && abs((mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) - mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2)-vvv)))/(mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) + mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2)-vvv))))>=alfa2
                            sl_mid(BD1(k,1), BD1(k,2)-vvv)=0;
                        end
                        % horizontal only current slice left side
                        if  im_mid(BD1(k,1), BD1(k,2)+vvv)<P(1) && abs((mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) - mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2)+vvv)))/(mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) + mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2)+vvv))))>=alfa2
                            sl_mid(BD1(k,1), BD1(k,2)+vvv)=0;
                        end
                        %vertical only current slice down side
                        if  im_mid(BD1(k,1)-vvv, BD1(k,2))<P(1) && abs((mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) - mean(im_mid(BD1(k,1)-vvv, BD1(k,2):BD1(k,2))))/(mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) + mean(im_mid(BD1(k,1)-vvv, BD1(k,2):BD1(k,2)))))>=alfa2
                            sl_mid(BD1(k,1)-vvv, BD1(k,2))=0;
                        end
                        %horizontal only current slice up side
                        if im_mid(BD1(k,1)+vvv, BD1(k,2))<P(1) && abs((mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) - mean(im_mid(BD1(k,1)+vvv, BD1(k,2):BD1(k,2))))/(mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) + mean(im_mid(BD1(k,1)+vvv, BD1(k,2):BD1(k,2)))))>=alfa2
                            sl_mid(BD1(k,1)+vvv, BD1(k,2))=0;
                        end
                        %diagonal only current slice up side
                        if im_mid(BD1(k,1)+vvv, BD1(k,2)+vvv)<P(1) && abs((mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) - mean(im_mid(BD1(k,1)+vvv, BD1(k,2):BD1(k,2)+vvv)))/(mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) + mean(im_mid(BD1(k,1)+vvv, BD1(k,2):BD1(k,2)+vvv))))>=alfa2
                            sl_mid(BD1(k,1)+vvv, BD1(k,2)+vvv)=0;
                        end
                        %diagonal only current slice down side
                        if im_mid(BD1(k,1)-vvv, BD1(k,2)-vvv)<P(1) && abs((mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) - mean(im_mid(BD1(k,1)-vvv, BD1(k,2):BD1(k,2)-vvv)))/(mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) + mean(im_mid(BD1(k,1)-vvv, BD1(k,2):BD1(k,2)-vvv))))>=alfa2
                            sl_mid(BD1(k,1)-vvv, BD1(k,2)-vvv)=0;
                        end
                        %diagonal only current slice crossdown side
                        if im_mid(BD1(k,1)+vvv, BD1(k,2)-vvv)<P(1) && abs((mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) - mean(im_mid(BD1(k,1)+vvv, BD1(k,2):BD1(k,2)-vvv)))/(mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) + mean(im_mid(BD1(k,1)+vvv, BD1(k,2):BD1(k,2)-vvv))))>=alfa2
                            sl_mid(BD1(k,1)+vvv, BD1(k,2)-vvv)=0;
                        end
                        %diagonal only current slice crossdown side
                        if  im_mid(BD1(k,1)-vvv, BD1(k,2)+vvv)<P(1) && abs((mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) - mean(im_mid(BD1(k,1)-vvv, BD1(k,2):BD1(k,2)+vvv)))/(mean(im_mid(BD1(k,1), BD1(k,2):BD1(k,2))) + mean(im_mid(BD1(k,1)-vvv, BD1(k,2):BD1(k,2)+vvv))))>=alfa2
                            sl_mid(BD1(k,1)-vvv, BD1(k,2)+vvv)=0;
                        end

                    end; clear vvv;
                end
            end; clear k BD1;
        end;clear zzz B L s;
    end

    if mfilt==1
        sl_mid=medfilt2(sl_mid, [3 3]);
    end

    [B, ~]= bwboundaries(sl_mid);

    if plt==1
        for kkk=1:length(B)
            BD=B{kkk};
            plot(BD(:,2), BD(:,1),'g', 'linewidth', 2);clear BD;
             text(round(size(sl_mid,1)/2),0,'Eroded','Color','g')
        end
        clear kkk; pause(0.1);
    end
    hold off;

    mask2(:,:,mmm)=sl_mid(4:end-3,4:end-3);
end

clear new_image mask xp

end
