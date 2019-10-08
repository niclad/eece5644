% Nicolas Tedori
% EECE 5644
% October 9, 2019
% Homework 2 - Question 2, Problem 4

function iid = p4(samples)
%% define statistic information
% as as 1 with different class priors
c1Mu    = [0; 0];
c2Mu    = [3; 3];
c1Cov   = eye(2);
c2Cov   = c1Cov;
pC1     = 0.05;
pC2     = 0.95;
plot    = 'q2p4';

%% generate iids and use a MAP classifier
iid = MAP_Classify(samples, c1Mu, c2Mu, c1Cov, c2Cov, pC1, pC2, plot);
end

