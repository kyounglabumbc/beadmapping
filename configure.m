function [ params ] = configure()
%CONFIGURE Summary of this function goes here
%   Detailed explanation goes here
    minRadius = input('Please enter the min radius (default is 2): ');
    maxRadius = input('Please enter the max radius (default is 7): ');
    sensitivity = input('Please enter the sensitivity (from 0 to 1, default is 1): ');
    edgethreshold = input('Please enter the edge threshold (from 0 to 1, default is 0.05): ');
    if(input('Do you want to change the output directory? Enter y or n: ', 's')=='y')
        outputPath = uigetdir('./');
    else
        outputPath = './';
    end
    params = cell(5,1);
    params{1} = minRadius;
    params{2} = maxRadius;
    params{3} = sensitivity;
    params{4} = edgethreshold;
    params{5} = outputPath;
    fileID = fopen('config.txt','w');
    for i=1:4
        fprintf(fileID, '%f,', params{i});
    end
    fprintf(fileID, '%s',params{5});
    %csvwrite('config.txt', params); %write the config file
    fclose(fileID);

end

