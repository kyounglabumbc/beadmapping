function [ x,y ] = poly2D( x_i,y_i,P,Q )
%POLY2D Summary of this function goes here
%   Detailed explanation goes here

n = size(P);
x = 0;
y=0;
for i = 1:n
    for j= 1:n
        x = x + P(i,j)*x_i^(j-1)*y_i^(i-1);
    end
end

for i = 1:n
    for j= 1:n
        y = y + Q(i,j)*x_i^(j-1)*y_i^(i-1);
    end
end

x = round(x);
y = round(y);

end

