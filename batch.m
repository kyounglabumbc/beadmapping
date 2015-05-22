function [ ] = batch( )
%BATCH Summary of this function goes here
%   Detailed explanation goes here

%get the directory from the user
%[FileName,PathName,FilterIndex]=uigetfile('*.sif;*.SIF', 'Select SIF'); % opens dialog to let the user select sif to open
PathName = uigetdir('./');
%directory is in PathName

%get an array of structs for all sif files in that directory
wildCardPath = strcat(PathName, '/*.sif');
files = dir(wildCardPath);

numFiles = size(files);
timeSteps = zeros(size(files));

coeffName = input ('Please enter a coefficient file name: ');
bleedFactor = input('Please enter a bleed factor: ');

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

for i=1:numFiles
   currentName = files(i).name;
   timeSteps(i) = input(strcat('Enter Time Step for file ',currentName,':  '));
end


for i=1:numFiles
   beadfinder(timeSteps(i), bleedFactor, num2str(coeffName), strcat(PathName,'/',files(i).name), params);
end





end

