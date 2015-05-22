
[A, fname] = readSif();
A = rot90(A);
avgA = mean(A,3);
X16 = uint16(3*avgA-1);
avgA = im2uint8(X16);
imwrite(avgA,strcat('C:\User\tir data\' ,fname(1),'_ave.tif'), 'tif');