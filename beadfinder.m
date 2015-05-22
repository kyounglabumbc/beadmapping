function [  ] = beadfinder(sensitivity, edgethreshold )




%RUN FROM beadmapping
coeffName = input('Please enter the coefficient file name: ', 's');
timeStep = input('Please enter the time step: ');
bleed = input('Please enter the bleed factor: ');
%read the image from the sif file

[A, fname] = (readSif());
A = rot90(A);
%get the average of all the frames
%avgA = im2uint16(mean(A, 3), 'indexed');
avgA = mean(A, 3);

%avgA = im2uint8(avgA);
%please fix this to set the correct scaling factor, hardcoded for now
%X16 = uint16(3*avgA -1);
%avgA = im2uint8(X16);
%imwrite(avgA, 'rawtiff.tif', 'tif');
%clean the result to reduce background noise
cleanA = clean(avgA, 7);
%cleanA = avgA;
%imwrite(avgA, 'cleantiff.tif', 'tif');
%find and plot the circles
[centers, radii] = findCircles(cleanA, 2, 7, sensitivity,edgethreshold);
%c = centers;
%r = radii;
%standardize the circles
[c, r] = cleanCircles(centers, radii, 5);
%c = centers;
%r = radii;
%coeffName = strcat('mapping/',fname(1),'rawtiff.coeff');
coeff = load(strcat('mapping/',coeffName, '.coeff'));
width = 512;

maxDist = 4*sqrt(2);
%get the rough pairs of points
[left, right] = findPairs(c, coeff, width, maxDist);
%create an affine transformation 
tForm = fitgeotrans(right, left, 'affine');

%make a copy to transform the right side
transCopy = cleanA;
leftCopy = cleanA;
leftCopy(:,257:512) = 0;
%zero out the left side of the copy
transCopy(:,1:256) = 0;

%get a reference point for both frames
spatRef = imref2d(size(avgA));


[warpIm, warpB] = imwarp(transCopy, tForm, 'OutputView', spatRef);



%fix rows

%figure(5);
%imagesc(warpIm);


%colormap gray;
%figure(1);
%imagesc(leftIm);
%colormap gray;
%figure(2);
%imagesc(warpIm);
%plot circles
colormap gray;
figure(2);

imagesc(avgA);

[lcenters, fradii] = findCircles(leftCopy+warpIm, 2, 7, 1);

%clean the circles, using the diameter as the min dist between two centers
[lcenters, fradii] = cleanCircles(lcenters, fradii, 2*max(fradii));
%standardize the nonzero radii
mask = fradii ~= 0;
fradii = max(fradii).*mask;
[m n]=size(lcenters);

rcenters = zeros(m,n);

for i=1:m
    [u,v] = transformPointsInverse(tForm,lcenters(i,1),lcenters(i,2));
    rcenters(i,:) = [u,v];
end

viscircles(lcenters, fradii,'EdgeColor','b');
viscircles(rcenters, fradii,'EdgeColor','b');
%show the circles
%imshow(im2uint16(avgA, 'indexed'));
%plot original
colormap gray;
figure(1);
colormap gray;
imagesc(avgA);
len = size([left;right]);
len = len(1);
%viscircles([left;right], 5*ones(len,1),'EdgeColor','b');

lefttraces = getTraces(A,lcenters, fradii);
righttraces = getTraces(A, rcenters,fradii);
%write the master csvs
csvwrite(strcat('./output/',fname(1),'masterleft.csv'), lefttraces);
csvwrite(strcat('./output/',fname(1), 'masterright.csv'), righttraces);
%csvwrite(strcat('output/',fname(1), 'coordinates.csv'), [leftcenters rightcenters]);
[r, c] = size(lefttraces);

newleft = lefttraces-bleed*righttraces;

%write the trace files
for bead=1:r
    traceMat = zeros(c-2,3);
    %starting time unit at 0
    time = 0;
    %skipping first and last frame
    for frame=2:(c-1)
        traceMat(frame-1,:) = [time, newleft(bead,frame), righttraces(bead,frame)];
        time = time + timeStep;
    end
    csvwrite(strcat('output/',fname(1),'trace',int2str(bead),'.csv'),traceMat);
end
end
