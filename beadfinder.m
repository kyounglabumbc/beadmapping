function [  ] = beadfinder()
[FileName,PathName,FilterIndex]=uigetfile('*.sif;*.SIF', 'Select SIF'); % opens dialog to let the user select sif to open
fname=strcat(PathName,FileName); % sets up the file name
try
    %try to load config file
    fileID = fopen('config.txt');
    %parameters are threshold, radius, timestep, bleed
    %factor, frame number, working directory and coefficient file name
    params = textscan(fileID, '%f,%f,%f,%f,%f,%f,%s');
    fclose(fileID);
catch
    %if config file not there, prompt for values and create it
    disp('Missing config file: ');
    params = configure();
end


%get the parameters
edgethreshold = params{1}; %default 2
radius = params{2}; %default 7
timeStep = params{3};
bleed = params{4};
frameNum = params{5};
coeffName = int2str(params{6});
path = strcat(params{7},'\');
if iscellstr(path)
    path = path{1};
end
%load the transformation file
tFname = strcat(path,'\mapping\',coeffName,'_warp.mat');
tFormStruct = load(tFname);
tForm = tFormStruct.tForm;

A = (readSif(fname));
disp('file loaded.');
A = rot90(A);
%get the average of all the frames
%avgA = im2uint16(mean(A, 3), 'indexed');
%avgA = mean(A, 3);

[s1,s2,length] = size(A);
if(frameNum>length)
   error('frame number exceeds number of frames');
end
avgA = A(:,:,frameNum);
%avgA = im2uint8(avgA);
%please fix this to set the correct scaling factor, hardcoded for now
%X16 = uint16(3*avgA -1);
%avgA = im2uint8(X16);
%imwrite(avgA, 'rawtiff.tif', 'tif');
%clean the result to reduce background noise
cleanA = clean(avgA, floor(0.45*radius));
%cleanA = avgA;
%imwrite(avgA, 'cleantiff.tif', 'tif');
%find and plot the circles

done = 0;
while(~done)
    [lcenters, rcenters, fradii] = changeThreshold(cleanA, radius, edgethreshold, tForm, avgA);
    if(input(strcat('Stopping threshold is currently_',num2str(edgethreshold),'. Would you like to change it? [y or n]'),'s')=='y')
        edgethreshold = input(strcat('Please enter a new threshold (image max is:_', num2str(max(max(cleanA))), '): '));
    else
        done = 1;
    end
end

[newLCircles, newRCircles, newRadii] = addCirclesManual(avgA, lcenters, rcenters, fradii, tForm);

% viscircles(lcenters, fradii,'EdgeColor','b');
% viscircles(rcenters, fradii,'EdgeColor','b');
%show the circles
%imshow(im2uint16(avgA, 'indexed'));
%plot original
lcenters = [lcenters; newLCircles];
rcenters = [rcenters; newRCircles];
fradii = [fradii; newRadii];


lefttraces = getTraces(A,lcenters, fradii);
righttraces = getTraces(A, rcenters,fradii);
%get the centers from matrix indices to x-y coordinates
%lcoordinates = [lcenters(:,2), 512-lcenters(:,1)];
%rcoordinates = [rcenters(:,2), 512-rcenters(:,1)];
%write the master csvs
ltracename = strcat(path,'\output\',fnameonly,'masterleft.csv');
rtracename = strcat(path,'\output\',fnameonly,'masterright.csv');
coordname = strcat(path,'\output\',fnameonly,'coordinates.csv');
try
    csvwrite(ltracename{1}, lefttraces);
    csvwrite(rtracename{1}, righttraces);
    csvwrite(coordname{1}, [lcenters(:,1),512-lcenters(:,2),rcenters(:,1),512-rcenters(:,2)]);
catch
    csvwrite(ltracename, lefttraces);
    csvwrite(rtracename, righttraces);
    csvwrite(coordname, [lcenters(:,1),512-lcenters(:,2),rcenters(:,1),512-rcenters(:,2)]);
end
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
    individualTraceOut = strcat(path,'\output\',fnameonly,'trace',int2str(bead),'.csv');
    try
        csvwrite(individualTraceOut{1},traceMat);
    catch
        csvwrite(individualTraceOut,traceMat);
    end
end
end
