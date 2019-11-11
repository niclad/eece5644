function [ ll, prob ] = E_Step_copy(x, mu, covm, wgt, nc)
%EXPECTATION_STEP Run the expectation step of EM
%   Detailed explanation goes here
% See: https://www.xarg.org/2016/06/the-log-sum-exp-trick-in-machine-learning/
% for information regarding the log-exp-sum trick. Could be useful for a
% more "correct" implementation.
% 
% Hopefully this will speed up the old E_Step

ptNum = size(x, 1);
parts = zeros(ptNum, nc);
prob  = zeros(ptNum, nc);

% calculate the likelihood that components are 

for k = 1:nc
    % get likelihood that an observation is in k cluster
    parts(:,k) = mvnpdf(x, mu(:, :, k), covm(:,:,k)) * wgt(:,:,k);
    
    % if it's very very unlikely an observation is in this cluster, make
    % sure Matlab can still process the data...
    % (by adding a very small number to that probability)
    % Note: There's probably a better way to do this (see log-exp-sum
    % trick), but some probabilities were on the oder of < 1e-100,
    % which (I assume) is a part of why I wsa experiencing XTREME
    % underflow
%     if parts(n, k) < 1e-12
%         parts(n, k) = parts(n, k) + 1e-12;
%     end
end

% see above comment for why this is done
testMat = parts <= 1e-12;
parts(testMat == 1) = parts(testMat == 1) + 1e-12;


partSum  = sum(parts, 2); % sum all the columns to normalize data

% get the posterior probability
prob = parts ./ partSum;

% get the log-likelihood. Used to find convergence
llVals = log(partSum);
ll     = sum(llVals);

end

