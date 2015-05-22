function [ xf, yf ] = transPoint( coeff, xi, yi )
%TRANSPOINT takes a coefficient vector of length 6 and the coordinates of a
%point.  Returns the transformed coordinates.

xf = coeff(1)+coeff(2)*xi+coeff(3)*yi;
yf = coeff(4)+coeff(5)*xi+coeff(6)*yi;


end

