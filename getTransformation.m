function [ tForm ] = getTransformation()
%CHANGETHRESHOLD Summary of this function goes here
%   Detailed explanation goes here
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

%[fpathonly, fnameonly, fext] = fileparts(fname);

A = (readSif(fname));
disp('file loaded.');
A = rot90(A);

%get the average of all the frames
[s1,s2,length] = size(A);
if(frameNum>length)
   error('frame number exceeds number of frames');
end
avgA = A(:,:,frameNum);
%clean the result to reduce background noise
cleanA = clean(avgA, floor(0.45*radius));

done = 0; 
while(~done)   
    %find all the circles in the image on both sides
    [centers, radii] = findCircles(cleanA, radius, edgethreshold);
    c = centers;
    r = radii;
    %coeffName = strcat('mapping/',fname(1),'rawtiff.coeff');
    coeff = load(strcat(path,'mapping\',coeffName,'.coeff'));
    width = 512;
    %if there's nothing in the picture, just error out
    if(size(c,1)<1)
        error('Did not find any signals!');
    end
    maxDist = 4*sqrt(2);
    %get the rough pairs of points
    [left, right] = findPairs(c, coeff, width, maxDist);
    disp(strcat('found ','_',int2str(size(left,1)), ' ',' pairs'));
    if(size(left,1)<3 || size(right,1)<3)
        disp('not enough pairs!');
    end
    rArtificial = radius*ones(size(left,1),1);
    %plot the circles found and ask for threshold change
    figure(1);
    colormap gray;
    imagesc(cleanA);
    viscircles(left, rArtificial,'EdgeColor','b');
    viscircles(right, rArtificial,'EdgeColor','b');

    if(input(strcat('Stopping threshold is currently: ','_',num2str(edgethreshold),'. Would you like to change it? [y or n]'),'s')=='y')
        edgethreshold = input(strcat('Please enter a new threshold (image max is: ','_',num2str(max(max(cleanA))), '): '));
    else
        done = 1;
    end
end
%when ok, create an affine transformation and save
tForm = fitgeotrans(right, left, 'affine');
save(strcat(path,'mapping\',coeffName,'_warp.mat'), 'tForm');

