function [mask3] = grow_regions(mask, new_image, plt, xp, params)
% GROW_REGIONS: Grows regions in the image based on intensity and connectivity.
%
% Inputs:
% - mask: The initial binary mask
% - new_image: The original image
% - plt: Plotting flag (1 to enable plotting, 0 to disable)
% - xp: Adaptive threshold parameter
% - params: Structure containing alpha, alpha2, and percentile threshold parameters.
%
% Outputs:
% - mask2: The refined binary mask after region growing.
disp('Region growing running...');

vect = new_image(new_image > 0);
P = prctile(vect, params.percentile - xp);
clear vect;

mask2 = zeros(size(mask));

alfa = params.alpha;  % threshold for contrast inclusion
alfa2 = params.alpha2;  % threshold for contrast exclusion

for mmm = 1:size(new_image, 3) - 1
    im_mid = new_image(:, :, mmm);
    sl_mid = mask(:, :, mmm);

    if sum(sl_mid(:)) > 0
        [B, ~] = bwboundaries(sl_mid);

        for zzz = 1:length(B)
            BD1 = B{zzz};

            for k = 1:length(BD1)
                for vvv = 1:4
                    if im_mid(BD1(k, 1), BD1(k, 2)) >= P && abs((mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) - mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2) - vvv))) / (mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) + mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2) - vvv)))) <= alfa
                        sl_mid(BD1(k, 1), BD1(k, 2) - vvv) = 1;
                    end
                    if im_mid(BD1(k, 1), BD1(k, 2)) >= P && abs((mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) - mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2) + vvv))) / (mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) + mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2) + vvv)))) <= alfa
                        sl_mid(BD1(k, 1), BD1(k, 2) + vvv) = 1;
                    end
                    if im_mid(BD1(k, 1), BD1(k, 2)) >= P && abs((mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) - mean(im_mid(BD1(k, 1) - vvv, BD1(k, 2):BD1(k, 2)))) / (mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) + mean(im_mid(BD1(k, 1) - vvv, BD1(k, 2):BD1(k, 2))))) <= alfa
                        sl_mid(BD1(k, 1) - vvv, BD1(k, 2)) = 1;
                    end
                    if im_mid(BD1(k, 1), BD1(k, 2)) >= P && abs((mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) - mean(im_mid(BD1(k, 1) + vvv, BD1(k, 2):BD1(k, 2)))) / (mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) + mean(im_mid(BD1(k, 1) + vvv, BD1(k, 2):BD1(k, 2))))) <= alfa
                        sl_mid(BD1(k, 1) + vvv, BD1(k, 2)) = 1;
                    end
                    if im_mid(BD1(k, 1), BD1(k, 2)) >= P && abs((mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) - mean(im_mid(BD1(k, 1) + vvv, BD1(k, 2):BD1(k, 2) + vvv))) / (mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) + mean(im_mid(BD1(k, 1) + vvv, BD1(k, 2):BD1(k, 2) + vvv)))) <= alfa
                        sl_mid(BD1(k, 1) + vvv, BD1(k, 2) + vvv) = 1;
                    end
                    if im_mid(BD1(k, 1), BD1(k, 2)) >= P && abs((mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) - mean(im_mid(BD1(k, 1) - vvv, BD1(k, 2):BD1(k, 2) - vvv))) / (mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) + mean(im_mid(BD1(k, 1) - vvv, BD1(k, 2):BD1(k, 2) - vvv)))) <= alfa
                        sl_mid(BD1(k, 1) - vvv, BD1(k, 2) - vvv) = 1;
                    end
                    if im_mid(BD1(k, 1), BD1(k, 2)) >= P && abs((mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) - mean(im_mid(BD1(k, 1) + vvv, BD1(k, 2):BD1(k, 2) - vvv))) / (mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) + mean(im_mid(BD1(k, 1) + vvv, BD1(k, 2):BD1(k, 2) - vvv)))) <= alfa
                        sl_mid(BD1(k, 1) + vvv, BD1(k, 2) - vvv) = 1;
                    end
                    if im_mid(BD1(k, 1), BD1(k, 2)) >= P && abs((mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) - mean(im_mid(BD1(k, 1) - vvv, BD1(k, 2):BD1(k, 2) + vvv))) / (mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) + mean(im_mid(BD1(k, 1) - vvv, BD1(k, 2):BD1(k, 2) + vvv)))) <= alfa
                        sl_mid(BD1(k, 1) - vvv, BD1(k, 2) + vvv) = 1;
                    end
                end; clear vvv;
            end; clear k BD1;
        end;clear zzz B L s;

        [B, ~] = bwboundaries(sl_mid);

        if plt == 1
            imshow(im_mid, [min(im_mid(:)) max(im_mid(:))]); hold on;
            for kkk = 1:length(B)
                BD = B{kkk};
                plot(BD(:, 2), BD(:, 1), 'r', 'linewidth', 2);
                text(0,10,'Dilated','Color','r');
                text(round(size(sl_mid,1)/2),10,'Eroded','Color','g')
            end
            clear kkk; pause(0.1);
        end

        

        for zzz = 1:length(B)
            BD1 = B{zzz};
            for k = 1:length(BD1)
                if ((BD1(k, 1) & BD1(k, 2)) ~= 1 && (BD1(k, 1) & BD1(k, 2)) ~= 2)
                    for vvv = 1:2
                        if im_mid(BD1(k, 1), BD1(k, 2) - vvv) <= P && abs((mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) - mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2) - vvv))) / (mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) + mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2) - vvv)))) > alfa2
                            sl_mid(BD1(k, 1), BD1(k, 2) - vvv) = 0;
                        end
                        if im_mid(BD1(k, 1), BD1(k, 2) + vvv) <= P && abs((mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) - mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2) + vvv))) / (mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) + mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2) + vvv)))) > alfa2
                            sl_mid(BD1(k, 1), BD1(k, 2) + vvv) = 0;
                        end
                        if im_mid(BD1(k, 1) - vvv, BD1(k, 2)) <= P && abs((mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) - mean(im_mid(BD1(k, 1) - vvv, BD1(k, 2):BD1(k, 2)))) / (mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) + mean(im_mid(BD1(k, 1) - vvv, BD1(k, 2):BD1(k, 2))))) > alfa2
                            sl_mid(BD1(k, 1) - vvv, BD1(k, 2)) = 0;
                        end
                        if im_mid(BD1(k, 1) + vvv, BD1(k, 2)) <= P && abs((mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) - mean(im_mid(BD1(k, 1) + vvv, BD1(k, 2):BD1(k, 2)))) / (mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) + mean(im_mid(BD1(k, 1) + vvv, BD1(k, 2):BD1(k, 2))))) > alfa2
                            sl_mid(BD1(k, 1) + vvv, BD1(k, 2)) = 0;
                        end
                        if im_mid(BD1(k, 1) + vvv, BD1(k, 2) + vvv) <= P && abs((mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) - mean(im_mid(BD1(k, 1) + vvv, BD1(k, 2):BD1(k, 2) + vvv))) / (mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) + mean(im_mid(BD1(k, 1) + vvv, BD1(k, 2):BD1(k, 2) + vvv)))) > alfa2
                            sl_mid(BD1(k, 1) + vvv, BD1(k, 2) + vvv) = 0;
                        end
                        if im_mid(BD1(k, 1) - vvv, BD1(k, 2) - vvv) <= P && abs((mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) - mean(im_mid(BD1(k, 1) - vvv, BD1(k, 2):BD1(k, 2) - vvv))) / (mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) + mean(im_mid(BD1(k, 1) - vvv, BD1(k, 2):BD1(k, 2) - vvv)))) > alfa2
                            sl_mid(BD1(k, 1) - vvv, BD1(k, 2) - vvv) = 0;
                        end
                        if im_mid(BD1(k, 1) + vvv, BD1(k, 2) - vvv) <= P && abs((mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) - mean(im_mid(BD1(k, 1) + vvv, BD1(k, 2):BD1(k, 2) - vvv))) / (mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) + mean(im_mid(BD1(k, 1) + vvv, BD1(k, 2):BD1(k, 2) - vvv)))) > alfa2
                            sl_mid(BD1(k, 1) + vvv, BD1(k, 2) - vvv) = 0;
                        end
                        if im_mid(BD1(k, 1) - vvv, BD1(k, 2) + vvv) <= P && abs((mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) - mean(im_mid(BD1(k, 1) - vvv, BD1(k, 2):BD1(k, 2) + vvv))) / (mean(im_mid(BD1(k, 1), BD1(k, 2):BD1(k, 2))) + mean(im_mid(BD1(k, 1) - vvv, BD1(k, 2):BD1(k, 2) + vvv)))) > alfa2
                            sl_mid(BD1(k, 1) - vvv, BD1(k, 2) + vvv) = 0;
                        end
                  
                    end; clear vvv;
                end
            end; clear k BD1;
        end;clear zzz B L s;
    end

  mask2(:, :, mmm) = sl_mid;

  [B, ~]= bwboundaries(sl_mid);

     if plt==1
        for kkk=1:length(B)
            BD=B{kkk};
            plot(BD(:,2), BD(:,1),'g', 'linewidth', 2);clear BD;
        end
        clear kkk; pause(0.1);
    end
    hold off;

end
mask3 = mask2;
end