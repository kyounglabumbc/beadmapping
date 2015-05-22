function [ A ] = intensify( M )
%INTENSIFY Summary of this function goes here
%   Detailed explanation goes here
[m,n] = size(M);
A = M;
for i=1:m
    for j=1:n
        if M(i,j)< 30
            A(i,j)= 0;
        else
            A(i,j) = M(i,j)*2;
        end
    end
end

end

