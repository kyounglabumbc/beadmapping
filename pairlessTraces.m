function [  ] = pairlessTraces(image, centers, radii, outputPath, fnameStem)
%PAIRLESSTRACES Summary of this function goes here
%   Detailed explanation goes here

%separate left and right centers,
%get the circles on the left side
lcenters = centers(centers(:,1)<(width/2),:);
lradii = radii(centers(:,1)<(width/2),:);
%this is inefficient, but ok for now
rcenters = centers(centers(:,1)>(width/2),:);
rradii= radii(centers(:,1)>(width/2),:);

lefttraces = getTraces(image,lcenters, lradii);
righttraces = getTraces(image, rcenters, rradii);
%get the centers from matrix indices to x-y coordinates
%lcoordinates = [lcenters(:,2), 512-lcenters(:,1)];
%rcoordinates = [rcenters(:,2), 512-rcenters(:,1)];
%write the master csvs
csvwrite(strcat(outputPath,fnameStem,'masterleft.csv'), lefttraces);
csvwrite(strcat(outputPath,fnameStem, 'masterright.csv'), righttraces);
csvwrite(strcat(outputPath,fnameStem, 'coordinates.csv'), [lcenters rcenters]);
[r, c] = size(lefttraces);

newright = righttraces-bleed*lefttraces;

%write the trace files
for bead=1:r
    traceMat = zeros(c-2,3);
    %starting time unit at 0
    time = 0;
    %skipping first and last frame
    for frame=2:(c-1)
        traceMat(frame-1,:) = [time, lefttraces(bead,frame), newright(bead,frame)];
        time = time + timeStep;
    end
    csvwrite(strcat(outputPath,fnameonly,'trace',int2str(bead),'.csv'),traceMat);
end

end

