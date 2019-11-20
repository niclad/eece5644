function [ uncertainty ] = info_gain(left,right,gini)
%INFO_GAIN Information Gain - uncertainty of parent node minus weighted
% impurity of child nodes

p = length(left) / (length(left) + length(right));

uncertainty = gini - p * gini_impurity(left) - ...
    (1 - p) * gini_impurity(right);
end

