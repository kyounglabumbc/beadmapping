function [ centers, radii ] = findCircles( imageArr, rMin, rMax, sensitivity , edgethreshold)
%FINDCIRCLES Summary of this function goes here
%   Detailed explanation goes here

%[centers, radii] = imfindcircles(imageArr,[rMin rMax],'ObjectPolarity','bright' ,'Sensitivity',sensitivity, 'EdgeThreshold', edgethreshold);

[centers, radii, mask] = findPeaks(imageArr, edgethreshold, rMax);

end

