function [ indices ] = map_classify(data, gmdist, k)
%MAP_CALSSIFY Classify a point using GMM components.
%   Note: gmdist should be a gmdistribution object
%   or a struct with properties of the same names.

% get gmm components
wgt = gmdist.ComponentProportion;   % 1-by-k array
mu  = gmdist.mu;                    % k-by-n matrix (n = size(data,2))
sig = gmdist.Sigma;                 % n-by-n-by-k matrix

m       = size(data, 1);    % get the dimensions of the data
mapVals = zeros(m, k);      % initialize map values matrix
                            % col: components
                            % row: post for obs

% calculate MAP for data and all components
for i = 1:k
    % calculate AP for an obs and a comp
    mapVals(:,i) = mvnpdf(data, mu(i,:), sig(:,:,i)) * wgt(i);
end

% get the MAP cluster value
[~,indices] = max(mapVals, [], 2);

end

