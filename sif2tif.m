[FileName,PathName,FilterIndex]=uigetfile('*.sif;*.SIF', 'Select SIF'); % opens dialog to let the user select sif to open
fname=strcat(PathName,FileName);
 A = readSif(fname);    
A = rot90(A);
[x, y, numFrames] = size(A);
subA = A(:,:,1:numFrames);
avgA = mean(subA,3);
%cast from 32-bit float to 16-bit uint and scale up to cast again
X16 = uint16(3*avgA-1);
%cast from 16-bit uint to 8-bit uint
avgA = im2uint8(X16);
[pathstr,fnameonly,ext] = fileparts(fname); 
imwrite(avgA,strcat(fnameonly,'_ave.tif'), 'tif');