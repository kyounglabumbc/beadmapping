function [ cleanImageArr ] = clean( dirtyImageArr, rad )
%CLEAN Summary of this function goes here
%   Detailed explanation goes here

background = imopen(dirtyImageArr,strel('disk',rad));

cleanImageArr = dirtyImageArr-background;

end

