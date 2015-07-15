function [ lcenters, rcenters, fradii ] = changeThreshold( cleanA, radius, edgethreshold, tForm, avgA )
%CHANGETHRESHOLD Summary of this function goes here
%   Detailed explanation goes here

   
%[centers, radii] = findCircles(cleanA, minRadius, maxRadius, sensitivity,edgethreshold);

%make a copy to transform the right side
transCopy = cleanA;
leftCopy = cleanA;
leftCopy(:,257:512) = 0;
%zero out the left side of the copy
transCopy(:,1:256) = 0;

%get a reference point for both frames
spatRef = imref2d(size(avgA));
%perform the transformation
[warpIm, warpB] = imwarp(transCopy, tForm, 'OutputView', spatRef);

%find circles in the overlay
%THIS COULD BE THE PROBLEM!!!!!!!!!!!!! 2*edgethreshold
[lcenters, fradii] = findCircles(leftCopy+warpIm, radius, edgethreshold);

%clean the circles, using the diameter as the min dist between two centers
%[lcenters, fradii] = cleanCircles(lcenters, fradii, 2*max(fradii));
%standardize the nonzero radii
%mask = fradii ~= 0; %create a mask for nonzero radii
%fradii = max(fradii).*mask;  %set all nonzero radii equal to max
[m n]=size(lcenters);

rcenters = zeros(m,n);

for i=1:m
    [u,v] = transformPointsInverse(tForm,lcenters(i,1),lcenters(i,2));
    rcenters(i,:) = [u,v];
end

figure(1);
colormap gray;
imagesc(cleanA);
viscircles(lcenters, fradii,'EdgeColor','b');
viscircles(rcenters, fradii,'EdgeColor','b');


end


