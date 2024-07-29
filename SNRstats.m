function [P,V,xp]=SNRstats(new_image)

vect=double(new_image(new_image>0));

V(1:3)= [length(vect) mean(vect) std(vect)]; %Stats for output - optional

xp=(1/((mean(vect)-std(vect))/std(vect)));

if (mean(vect)/std(vect))>4 %% IF SNR is above Rician noise level
    P=95.5+xp
elseif (mean(vect)/std(vect))>2 && (mean(vect)/std(vect))<=4
    P=95.5;
else
    P=95.5-xp;  %% If the percentile threshold should be lowered as the image is affected by Rician noise
end

end