a = imread('rawtiff.tif');
PQ = load('raw.map');
P = reshape(PQ(1:16), 4, 4);
Q = reshape(PQ(17:32), 4, 4);
left = a(:,1:512);
right = a(:,513:1024);

rightOut = left;

for j = 1:1024
    for i = 1:512
        [x_f, y_f] = poly2D(i,j,P',Q');
        if x_f < 1024 && y_f < 512 
            rightOut(j,i) = left(x_f, y_f);
        end
    end
end

figure(1)
imshow(right);
figure(2);
imshow(rightOut);
