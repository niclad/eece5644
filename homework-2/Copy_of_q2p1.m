% Nicolas Tedori
% EECE 5644
% Homework 2 - Question 2, Problem 1

function iid = q2p1(samples)
% Generates a specified number of IID samples
%   Taking in a specified number of samples, the function returns a number
%   of IID samples paired with class labels

%% samples = 400; means = [0;0], [3;3]; covMat = I; pC1 == pC2

% class means
c1Mu = [0; 0];
c2Mu = [3; 3];

% covariance matrices
c1Cov = eye(2);
c2Cov = c1Cov;

% class priors (equal)
pC1 = 0.5;
pC2 = pC1;

% generate gaussian data; mvrnd generates n random samples from gaussian
% pdf
r1 = mvnrnd(c1Mu, c1Cov, samples);
r2 = mvnrnd(c2Mu, c2Cov, samples);
x = [r1; r2];
scatter(x(:, 1), x(:, 2), 10, '.')





% define output
iid = horzcat(xC1, xC2);    % concatinate mats
classLabels = {'Class 1 X1','Class 1 X2', 'Class 2 X1', 'Class 2 X2'};
iid = array2table(iid, 'VariableNames', classLabels);     % make a table

end