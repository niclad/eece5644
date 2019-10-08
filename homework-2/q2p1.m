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
xC1 = mvnrnd(c1Mu, c1Cov, samples);
xC2 = mvnrnd(c2Mu, c2Cov, samples);

% plot the data
hold on

plot(xC1(:, 1), xC1(:, 2), 'ob')
plot(xC2(:, 1), xC2(:, 2), 'xr')
title({'Samples=400, means=[0;0], [3;3]';'Identity Cov, equal priors'})
xlabel('x1')
ylabel('x2')
legend('Class 1', 'Class 2')

% save plot(s)
print -depsc plotQ2P1.eps

% MAP estimate
muMAP1 = ((sum(xC1) * c1Cov) + (c1Cov * pC1)) / (c1Cov * (samples + 1))
muMAP2 = ((sum(xC2) * c2Cov) + (c2Cov * pC2)) / (c2Cov * (samples + 1))

map1 = max( xC1 .* pC1 )    % MAP estimate for class 1
map2 = max( xC2 .* pC2 )    % MAP estimate for class 2

plot(map1(1,1), map1(1,2), '+m')
plot(map2(1,1), map2(1,2), 'dc')
legend('Class 1', 'Class 2', 'MAP C1', 'MAP C2')


% define output
iid = horzcat(xC1, xC2);    % concatinate mats
classLabels = {'Class 1 X1','Class 1 X2', 'Class 2 X1', 'Class 2 X2'};
iid = array2table(iid, 'VariableNames', classLabels);     % make a table

end