function [ mergedCentroids, mergedRadii ] = mergeCentroids( newCentroids, oldCentroids,newRadii , oldRadii, labelMask, maxRadius )
%MERGECENTROIDS Summary of this function goes here
%   Detailed explanation goes here
    [r,s] = size(oldCentroids);
    [m,n] = size(newCentroids);

    
    
    %first get a list of the old centroid labels
    oldCLabels = zeros(r,1);
    for i=1:r
       %we are flipping the coordinates to get matrix coordinates
        %also need to subtract the row from the size of the mask
       row = oldCentroids(i,2);  %y
       col = oldCentroids(i,1);  %x
       curLabel = labelMask(row, col);
       oldCLabels(i) = curLabel; 
    end
    
    %also get a list of radii for the regions here
    mergedRadii = zeros(r,1);
    
    for i=1:r
       curLabel = oldCLabels(i);        
       if(sum(ismember(curLabel,oldCLabels))>1) %if the current label is already in the array, delete the centroid
            mergedRadii(i) = oldRadii(i);
       else
           if(newRadii(curLabel) <= maxRadius)
                mergedRadii(i) = newRadii(curLabel);
           else
               mergedRadii(i) = oldRadii(i);
           end
       end
      
      
    end

        newCLabels = zeros(m,1);
        acceptedNewCentroids = zeros(m,2);
        newCentroidRadii = zeros(m,1);
        counterIndex = 1;
    for i=1:m
        %we are flipping the coordinates to get matrix coordinates
        %also need to subtract the row from the size of the mask
       row = newCentroids(i,2);  %y
       col = newCentroids(i,1);  %x
       curLabel = labelMask(row, col);
            
       if(newRadii(i) <= maxRadius && curLabel > 0)         
                newCLabels(counterIndex) = curLabel;  
                acceptedNewCentroids(counterIndex,:) = newCentroids(i,:);
                newCentroidRadii(counterIndex) = newRadii(i);
                counterIndex = counterIndex + 1;
       end
    end
    %get the indexes of the members of the new centroid labels that aren't 
    %already in the list of old centroid labels
    uniqueIndices = ~ismember(newCLabels, oldCLabels);
    uniqueIndices = uniqueIndices(1:counterIndex-1);
    %make an array containing only the centroids that aren't already in our
    %list
    acceptedNewCentroids = acceptedNewCentroids(uniqueIndices,:);
    newAcceptedRadii = newCentroidRadii(uniqueIndices,:);
    %append the new centroids to the end of the list
    mergedCentroids = [oldCentroids; acceptedNewCentroids];
    mergedRadii = [mergedRadii; newAcceptedRadii];
end

