function [ xy ] = rndpt(rRange, cRange, samples)
%RNDPT Randomly generate a point within the given ranges
%   Detailed explanation goes here

% get a random distance-from-origin and angle from unifrnd
radius = unifrnd(rRange.lower, rRange.upper, samples, 1);
angle  = unifrnd(cRange.lower, cRange.upper, samples, 1);

% convert values to cartesian coordinates
[x,y] = pol2cart(angle, radius);
xy = [x,y];
end

