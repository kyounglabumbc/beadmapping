function [centroids, radii, labelmask ] = findPeaks( image, MinThreshold, maxRadius)
%IMTHRESHOLD Summary of this function goes here
%   Detailed explanation goes here
    MaxThreshold = max(max(image));
    
    centroids = [];
    radii = [];
    labelmask = zeros(size(image));
   
        for i = MaxThreshold :-1000: MinThreshold
            mask = imThreshold(image, i);
            labelMask = bwlabel(mask); % finds the connected objects
            rads=regionprops(labelMask,'MajorAxisLength');
            %check for max radius limit
            newRadii = cat(1,rads.MajorAxisLength)/2;
            
            %otherwise, continue
            s=regionprops(labelMask,'Centroid');
            newCentroids=cat(1,s.Centroid);    % acquires the centroid position of each connected object
            newCentroids = round(newCentroids);
            [centroids, radii] = mergeCentroids(newCentroids, centroids, newRadii,radii,labelMask ,maxRadius);
            
        end        


end
