

 [FileName,PathName,FilterIndex]=uigetfile('*.sif;*.SIF', 'Select SIF'); % opens dialog to let the user select sif to open
fname=strcat(PathName,FileName);
 A = readSif(fname);    
A = rot90(A);
[x, y, numFrames] = size(A);
test = A(:,:,60:numFrames);
avgA = mean(test,3);
%X16 = uint16(3*avgA-1);
avgA = uint16(avgA);
[pathstr,fnameonly,ext] = fileparts(fname); 
imwrite(avgA,strcat(fnameonly,'_ave.tif'), 'tif');