function [  ] = beadfinder(timeStep, bleed, coeffName, fname, params)
if nargin == 0 %if no arguments, we are not batching
    %non batch option
    [FileName,PathName,FilterIndex]=uigetfile('*.sif;*.SIF', 'Select SIF'); % opens dialog to let the user select sif to open
    fname=strcat(PathName,FileName); % sets up the file name
    coeffName = input('Please enter the coefficient file name: ', 's');
    timeStep = input('Please enter the time step: ');
    bleed = input('Please enter the bleed factor: ');
    %check if you want to change config
    if(input('Would you like to change the config? Enter y or n: ', 's') == 'y')
        params = configure();
    else %if not, load the config
        try
            %try to load config file
            fileID = fopen('config.txt');
            params = textscan(fileID, '%f,%f,%f,%f,%s');
            fclose(fileID);
        catch
            %if config file not there, prompt for values and create it
            disp('Missing config file: ');
            params = configure();
        end
    end
end

minRadius = params{1}; %default 2
maxRadius = params{2}; %default 7
sensitivity = params{3};
edgethreshold = params{4};
outputPath = strcat(params{5}{1},'/');
[fpathonly, fnameonly, fext] = fileparts(fname);

A = (readSif(fname));
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
[centers, radii] = findCircles(cleanA, minRadius, maxRadius, sensitivity,edgethreshold);
%c = centers;
%r = radii;
%standardize the circles
[c, r] = cleanCircles(centers, radii, 2*max(radii));
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

[lcenters, fradii] = findCircles(leftCopy+warpIm, minRadius, maxRadius, sensitivity, edgethreshold);

%clean the circles, using the diameter as the min dist between two centers
[lcenters, fradii] = cleanCircles(lcenters, fradii, 2*max(fradii));
%standardize the nonzero radii
mask = fradii ~= 0; %create a mask for nonzero radii
fradii = max(fradii).*mask;  %set all nonzero radii equal to max
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
csvwrite(strcat(outputPath,fnameonly,'masterleft.csv'), lefttraces);
csvwrite(strcat(outputPath,fnameonly, 'masterright.csv'), righttraces);
csvwrite(strcat(outputPath,fnameonly, 'coordinates.csv'), [lcenters rcenters]);
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
    csvwrite(strcat(outputPath,fnameonly,'trace',int2str(bead),'.csv'),traceMat);
end
end
