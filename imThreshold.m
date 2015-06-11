function [ mask ] = imThreshold( image, intensity_threshold )
%IMTHRESHOLD Summary of this function goes here
%   Detailed explanation goes here
    min_number_pixel_per_peak=1;
    extension_parameter =5;
    mask=image>intensity_threshold;
    mask=bwareaopen(mask,min_number_pixel_per_peak);  % removes small spots
    mask = double(mask);

    mask_smooth=smooth(mask, extension_parameter);  
    [size_I_col, size_I_row]=size(mask);
    mask_extend=reshape(mask_smooth, size_I_col, size_I_row);
    
    mask_smooth_2=smooth(mask_extend', extension_parameter);
    mask_extend_2=reshape(mask_smooth_2, size_I_row, size_I_col)';
       
    mask=mask_extend_2>0;
end

