function [ centers, radii ] = findCircles( imageArr, radius, edgethreshold)
%FINDCIRCLES Summary of this function goes here
%   Detailed explanation goes here

%get the initial centers with variable radii
[centers, radii, mask] = findPeaks(imageArr, edgethreshold, radius);
%standardize the radii by removing anything smaller than the user-spec
goodRadii = radii == radius;
centers = centers(goodRadii,:);
radii = radii(goodRadii,:);

end

