% Nicolas Tedori
% EECE 5644
% October 9, 2019
% Homework 2 - Question 2, Problem 2

function iid = p2(samples)
%% define statistic information
% parameters same as 1 except covs
c1Mu    = [0; 0];
c2Mu    = [3; 3];
c1Cov   = [3, 1; 1, 0.8];
c2Cov   = c1Cov;
pC1     = 0.5;
pC2     = pC1;
plot    = 'q2p2';

%% generate iids and use a MAP classifier
iid = MAP_Classify(samples, c1Mu, c2Mu, c1Cov, c2Cov, pC1, pC2, plot);
end

