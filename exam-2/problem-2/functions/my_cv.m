function [ results ] = my_cv(estLoc, yLoc)
%MY_CV Summary of this function goes here
%   Detailed explanation goes here
results =  mean(vecnorm((estLoc - yLoc),2,2).^2);

end

