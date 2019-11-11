function [ centroids ] = compute_centroids(data, index, k)
%COMPUTE_CENTROIDS Recalculate the centroids with new data
%   Detailed explanation goes here

[m, n]    = size(data);
centroids = zeros(k, n);

for i = 1:k
    x_i = data(index == i, :);
    c_k = size(x_i, 1);
    centroids(i, :) = (1 / c_k) * sum(x_i);
end

end

