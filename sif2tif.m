

 [FileName,PathName,FilterIndex]=uigetfile('*.sif;*.SIF', 'Select SIF'); % opens dialog to let the user select sif to open
fname=strcat(PathName,FileName);
 A = readSif(fname);    
A = rot90(A);
avgA = mean(A,3);
X16 = uint16(3*avgA-1);
avgA = im2uint8(X16);
[pathstr,fnameonly,ext] = fileparts(fname); 
imwrite(avgA,strcat('C:\User\tir data\' ,fnameonly,'_ave.tif'), 'tif');