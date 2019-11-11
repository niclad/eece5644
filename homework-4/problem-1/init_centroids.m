function [ centroids ] = init_centroids(data, k)
%INIT_CENTROIDS Randomly initialize centroids for k-means
%   this is good

randIdx   = randperm(size(data, 1));     % get random indices
centroids = data(randIdx(1:k), :);

end

