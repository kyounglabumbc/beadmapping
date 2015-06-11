function [ cleanImageArr ] = clean( dirtyImageArr, rad )
%CLEAN Summary of this function goes here
%   Detailed explanation goes here

background = imopen(dirtyImageArr,strel('disk',rad));

cleanImageArr = dirtyImageArr-background;

%now apply a gaussian filter
h=fspecial('gaussian',[3 3],1);
cleanImageArr=imfilter(cleanImageArr,h,'replicate','conv');

end

