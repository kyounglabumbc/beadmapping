function [ leftCircles, rightCircles ] = findPairs(centers, coeff, width, maxDist)
%FINDPAIRS Summary of this function goes here
%   Input: list of circle centers to sift through for pairs, coefficient vector,
%   width of the full image, the maximum distance from the transformed point on the
%   right side to look for a center of a paired point
%   Detailed explanation goes here

    %get the circles on the left side
    left = centers(centers(:,1)<(width/2),:);
    %this is inefficient, but ok for now
    right = centers(centers(:,1)>(width/2),:);
    leftCircles = [];
    rightCircles = [];
    n = size(left); %get the dimensions of the centers matrix (nx2)
    n = n(1); %get just the number of rows (points)
    for i=1:n
        %get the transformed point on the right side
        [xf, yf] = transPoint(coeff,left(i,1), left(i,2));
        [d,p] = min((right(:,1)-xf).^2 + (right(:,2)-yf).^2);            
        d = sqrt(d);
        if d < maxDist
            leftCircles = [ leftCircles; left(i,:) ];
            rightCircles = [ rightCircles; right(p,:) ];
        end
    end

end

