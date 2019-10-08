% Nicolas Tedori
% EECE 5644
% Homework 2 - Question 2

function [iid] = q2(samples)
% Generates a specified number of IID samples
%   Taking in a specified number of samples, the function returns a number
%   of IID samples paired with class labels

% initialize a "template" matrix
tempMat = zeros((samples + 1), 2);
colNames = {'class 1', 'class 2'};
tempMat = array2table(tempMat, 'VariableNames', colNames);
normData = tempMat;

%% 0. define a range to generate the samples.
%samples = samples / 2;

%% 1. samples = 400; means = [0;0], [3;3]; covMat = I; pC1 == pC2

% initialize data matrices
dataMat = tempMat;
% class means
c1Mu = [0; 0];
c2Mu = [3; 3];

% covariance matrices
c1Cov = eye(2);
c2Cov = c1Cov;

% class priors (equal)
pC1 = 0.5;
pC2 = pC1;

% generate gaussian data
c1X = mvnrnd(c1Mu, c1Cov, samples);
c2X = mvnrnd(c2Mu, c2Cov, samples);
%dataMat(:, 1) = mvnpdf(x1, c1Mu, c1Cov);
%dataMat(:, 2) = mvnpdf(x2, c2Mu, c2Cov);

% for x = -samples:samples
%     rowNum = x + 1;  % increase the value of x to not erase column labels
%     dataMat(rowNum, 1) = normpdf(x, c1Mu, c1Cov);
%     dataMat(rowNum, 2) = normpdf(x, c2Mu, c2Cov);
% end

% normalize the columns of data independently
%normData(:, 1) = normalize(dataMat(:, 1));
%normData(:, 2) = normalize(dataMat(:, 2));

hold on
plot(c1X(:, 1), c1X(:, 2), 'ob')
plot(c2X(:, 1), c2X(:, 2), 'xr')
legend('Class 1', 'Class 2')
xlabel('x1')
ylabel('x2')

% save plots
print -depsc plot1.eps

%iid = normData;

end

