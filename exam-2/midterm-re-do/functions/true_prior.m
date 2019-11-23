function [ pXY ] = true_prior(sx, sy, x, y)
%YTUR_PRIOR Summary of this function goes here
%   Detailed explanation goes here

pXY = (1 / (2*pi*sx*sy)) * exp(-0.5 * [x, y] * inv([sx^2 0; 0 sy^2]) * [x;y]);

end

