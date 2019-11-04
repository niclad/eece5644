function [ final ] = sigmoid(result)
%OPTIMIZATION_PROBLEM Function for the parameter optimization
%   Detailed explanation goes here
result
final = 1 / (1 + exp(result));

end

