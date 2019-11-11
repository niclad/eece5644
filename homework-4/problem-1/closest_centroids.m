function [ indices ] = closest_centroids(data, centroids, k)
%CLOSEST_CENTROIDS Find the closest centroids to a data point
%   Detailed explanation goes here

m       = size(data, 1);               % get the dimensions of data
dist    = zeros(m, k);              % matrix for distance calculations

% calculate the euclidean distances from a point to a centroid
for i = 1:k
    % calculate the euclidean distances between all data and a centroid
    dist(:,i) = vecnorm((data - centroids(i,:)), 2, 2);
end

[~,indices] = min(dist, [], 2);     % get cluster number that the data likely belongs to

end

