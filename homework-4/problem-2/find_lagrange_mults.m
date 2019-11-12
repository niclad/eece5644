function [ alpha ] = find_lagrange_mults(data, indices)
%FIND_LAGRANGE_MULTS Get the multipliers using quadprog
%   Detailed explanation goes here

% correctly format classes
y = indices;
y(indices == 1) = -1;
y(indices == 2) =  1;



end