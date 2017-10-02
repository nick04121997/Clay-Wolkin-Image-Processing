function dng_process(filename, crop, white, lin, color, bright)
% function [raw, raw_cropped] = dng_process(filename)
% perform image processing steps on DNG files 
% uses MATLAB's Tiff library since DNG is similiar to TIFF

% don't display TIFF library warnings
% (there are unknown fields, reduces clutter in command window)
warning off MATLAB:tifflib:TIFFReadDirectory:libraryWarning

% Read Bayer CFA
t = Tiff(filename,'r'); % read data from file
offsets = getTag(t,'SubIFD'); 
setSubDirectory(t,offsets(1));
raw = read(t); % Bayer CFA data
close(t);
meta_info = imfinfo(filename); % Get meta data

% Crop to only valid pixels
if crop == 1
    x_origin = meta_info.SubIFDs{1}.ActiveArea(2)+1; % +1 due to MATLAB indexing
    y_origin = meta_info.SubIFDs{1}.ActiveArea(1)+1;
    width = meta_info.SubIFDs{1}.DefaultCropSize(1);
    height = meta_info.SubIFDs{1}.DefaultCropSize(2);
    raw = double(raw(y_origin:y_origin+height-1,x_origin:x_origin+width-1));
end

% Linearization
if lin == 1
    black = meta_info.SubIFDs{1}.BlackLevel(1);
    saturation = meta_info.SubIFDs{1}.WhiteLevel;
    raw = (raw - black)/(saturation - black);
    raw = max(0,min(raw,1));
end

% White balancing
% AsShotNeutral tag = multipliers values [R G B] 
%  for white balancing calculated at time of shooting
if white == 1
    wb_multi = (meta_info.AsShotNeutral).^-1;
    green = wb_multi(2); % value of green multiplier
    wb_multi = wb_multi/green; % rescale such that green multiplier = 1
    mask = white_balance(size(raw,1),size(raw,2),wb_multi,'rggb');
    raw = (raw .* mask);
end

% Demosaicing (using MATLAB's built in demosaic function)
temp = uint16(raw/max(raw(:))*2^16);
raw = double(demosaic(temp,'rggb'))/2^16;

% Color space conversion
if color == 1
    color_matrix = [0.6461   -0.0907   -0.0882;
        -0.4300    1.2184    0.2378;
        -0.0819    0.1944    0.5931];
    xyz2cam = color_matrix;
    rgb2xyz = [0.4124564 0.3575761 0.1804375;
        0.2126729 0.7151522 0.0721750;
        0.0193339 0.1191920 0.9503041];

    rgb2cam = xyz2cam * rgb2xyz; % Assuming previously defined matrices
    rgb2cam = rgb2cam ./ repmat(sum(rgb2cam,2),1,3); % Normalize rows to 1
    cam2rgb = rgb2cam^-1;
    raw = cs_conversion(raw, cam2rgb);
    raw = max(0,min(raw,1)); 
end

% Brightness and Gamma Correction
% grayim = rgb2gray(raw_corrected);
% grayscale = 0.25/mean(grayim(:));
% bright_srgb = min(1,raw_corrected*grayscale);
% raw_final = bright_srgb.^(1/2.2);

if bright == 1
    raw = raw*10;
end

% Display and save file
imtool(raw)
% png_name = strrep(filename,'.dng','.png');
% imwrite(raw,png_name);
