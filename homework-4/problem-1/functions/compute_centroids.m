function [ centroids ] = compute_centroids(data, index, k)
%COMPUTE_CENTROIDS Recalculate the centroids with new data
%   Detailed explanation goes here

n         = size(data, 2);  % number of columns in data (in this case 5)
centroids = zeros(k, n);    % initialize centroids array

for i = 1:k
    x_i = data(index == i, :);      % get the data that belongs to cluster i
    centroids(i, :) = mean(x_i);    % get the mean for this set of data
end

end

