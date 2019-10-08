% Nicolas Tedori
% EECE 5644
% October 9, 2019
% Homework 2 - Question 2, Problem 6

function iid = p6(samples)
%% define statistic information
c1Mu    = [0; 0];
c2Mu    = [2; 2];
c1Cov   = [2, 0.5; 0.5, 1];
c2Cov   = [2, -1.9; -1.9, 5];
pC1     = 0.05;
pC2     = 0.95;
plot    = 'q2p6';

%% generate iids and use a MAP classifier
iid = MAP_Classify(samples, c1Mu, c2Mu, c1Cov, c2Cov, pC1, pC2, plot);
end

