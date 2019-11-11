function [ indices ] = closest_centroids(data, centroids, k)
%CLOSEST_CENTROIDS Find the closest centroids to a data point
%   Detailed explanation goes here

m       = size(data);               % get the dimensions of data
indices = zeros(size(data, 1), 1);  % initialize array for indices
numObs  = m;                        % get number of data obs
dist    = zeros(m, k);              % matrix for distance calculations

% calculate the euclidean distances from a point to a centroid
for i = 1:k
    % calculate the euclidean distances between all data and a centroid
    dist(:,i) = vecnorm((data - centroids), 2, 2);
end

indices = min(dist, [], 2);     % get the minimum value for a 

end

