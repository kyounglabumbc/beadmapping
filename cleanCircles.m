function [ cleanCenters, cleanRadii ] = cleanCircles( centers, radii, minDist )
%CLEANCIRCLES Summary of this function goes here
%   Detailed explanation goes here
%first get the pairwise distances between all the centers
%distances are in an array like [(2,1), (3,1),
%...(n,1),(3,2),(4,2)...(n,2)...]
distances = pdist(centers, 'euclidean');
%scan for distances below some threshold

for i=1:length(distances)
    if(distances(i)<minDist)
        %first get the two center indexes being compared
        circle1=0; %k is the index of the first circle's center
        j=1; %indexer
        n = length(centers);
        while j<=i
           circle1 = circle1+1;
           n = n-1;
           j = j+n;
        end
        circle2=length(centers)+1-(j-i);  
        %then determine which one has the smaller radius and make it 0
        if(radii(circle1)>radii(circle2))
            radii(circle2)=0;
        else
            radii(circle1)=0;
        end
        
    end
    

        
end
    cleanCenters = centers(find(radii~=0),:);
    cleanRadii = radii(find(radii~=0));
end







