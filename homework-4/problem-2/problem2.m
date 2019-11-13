% Nicolas Tedori
% EECE 5644 
% November 14, 2019
% Homework 4 - Problem 2

close all

% add the functions path
addpath(genpath('./functions/'))

% time program
timeStart = cputime;

%% Define data constants
% class -1 (1)
mu1  = [0,0];   % zero-mean for class -1
sig1 = eye(2);  % identity covariance matrix for class -1
wgt1 = 0.35;    % weight for class -1

% class +1 (2)
rRange.lower = 2;
rRange.upper = 3;
cRange.lower = -pi;
cRange.upper =  pi;
wgt2 = 0.65;

%% Generate Data
SAMPLES = 1000;     % number of samples to generate

% generate the data
[data,indices,nClass] = generate_data(mu1, sig1, [wgt1, wgt2], rRange, ...
    cRange, SAMPLES);

% shuffle the rows of the data
nRows   = size(data, 1);        % the number of observations
order   = randperm(nRows);      % the new order of the data (and indices)
data    = [data, indices];      % combine the matrices for shuffling
data    = data(order, :);       % shuffle the rows
indices = data(:,end);          % get the shuffled indiced
data    = data(:,1:end-1);      % get the data into its own matrix

% plot the data
figure(1)
scatter(data(indices==1, 1), data(indices==1, 2), '.b');    % plot class -1
hold on
scatter(data(indices==2, 1), data(indices==2, 2), '.r');    % plot class +1
% configure the axes settings
set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin', ...
    'linewidth', 1, 'fontsize', 12, 'fontweight', 'bold', 'layer', 'top');
box on
axis([-3.5 3.5 -3.5 3.5])           % axis range and domain
xlabel('x1')                        % x-axis label
ylabel('x2')                        % y-axis label
legend({'class -1', 'class +1'})    % data key
title('Training Data')
hold off

%{
Note: if the data shuffled correctly, the plot produced prior to shuffling
and post shuffling should be identical (in my own test, they are).
%}

%% Set up cross-validation data
k  = 10;                                   % number of folds
kf = cvpartition(indices, 'KFold', k);     % 10-fold data

% get the number of data points to train and test
nTrain = sum(kf.training(1));   % for this problem, should be 900 
nTest  = sum(kf.test(1));       % for this problem, should be 100

% initialize cv matrices. Ea. row is an obsvervation. Each column is a
% catergory. Each page (ie 3rd dimension) is a k.
trainData = zeros(nTrain, 2, k);    % data to train on
trainIdx  = zeros(nTrain, 1, k);    % classes for that data
testData  = zeros(nTest, 2, k);     % data to test on
testIdx   = zeros(nTest, 1, k);     % classes for that data

% loop through train and test indices to get datasets
for i = 1:k
    % get the selection vectors (1 for add, 0 for no)
    selTrain = kf.training(i);
    selTest  = kf.test(i);
    
    % add the data
    trainData(:,:,i) = data(selTrain == 1, :);
    trainIdx(:,:,i)  = indices(selTrain == 1);
    testData(:,:,i)  = data(selTest == 1, :);
    testIdx(:,:,i)   = indices(selTest == 1);
end

%% Get Linear-SVM values
C = logspace(-3, 3, 10);        % define values of C to test

completeResultsL = cell(k, 1);
for i = 1:k
    td = [trainData(:,:,i), vecnorm(trainData(:,:,i), 2, 2).^2];
    testd = [testData(:,:,i), vecnorm(testData(:,:,i), 2, 2).^2];
    errs = zeros(length(C), 1);
    tempResults = cell(length(C), 1);
    for tc = 1:length(C)
%a = svm_fit(td, trainIdx(:,:,1), @linear_kernel, testC);
        testC = C(tc);
        [mdl,w,b] = svm_fit_hack(td, trainIdx(:,:,i), @linear_kernel, ...
            testC);
        errs(tc) = loss(mdl, testd, testIdx(:,:,i));
        scn      = mdl.KernelParameters.Scale;
        tempResults{tc} = TestResult(w, b, errs(tc), testC, scn, i, mdl);
    end
    [~,I] = min(errs);
    completeResultsL{i} = tempResults{I};
end

% plot the C v error
errs = zeros(length(completeResultsL), 1);
for i = 1:length(completeResultsL)
    errs(i) = completeResultsL{i}.err;
end
figure(2)
plot(1:10, errs, '-ok')

% get best model
[~,I] = min(errs);
bestL = completeResultsL{I};
title({sprintf('Error for each fold. Min e=%.3E', errs(I)); 'Linear-SVM'});
xlabel('Fold number')
ylabel('Error')

%% Get Gaussian-SVM values

completeResultsG = cell(k, 1);
for i = 1:k
    errs = zeros(length(C), 1);
    tempResults = cell(length(C), 1);
    for tc = 1:length(C)
        testC = C(tc);
        
        [mdl,w,b] = svm_fit_hack(trainData(:,:,i), trainIdx(:,:,i), ...
            @guassian_kernel, testC);
        
        errs(tc) = loss(mdl, testData(:,:,i), testIdx(:,:,i));
        scn      = mdl.KernelParameters.Scale;
        tempResults{tc} = TestResult(w, b, errs(tc), testC, scn, i, mdl);
    end
    [~,I] = min(errs);
    completeResultsG{i} = tempResults{I};
end

% plot the C v error
errs = zeros(length(completeResultsG), 1);
for i = 1:length(completeResultsG)
    errs(i) = completeResultsG{i}.err;
end
figure(3)
plot(1:10, errs, '-ok')

% get best model
[~,I] = min(errs);
bestG = completeResultsG{I};
title({sprintf('Error for each fold. Min e=%.3E', errs(I));'Gaussian-SVM'});
xlabel('Fold number')
ylabel('Error')


%% test on original data 
figure(4)
data3 = [data, vecnorm(data, 2, 2).^2];
bestL.train(data3, indices);
figure(5)
bestG.train(data, indices);

%% regenerate data to test on
[fullData,fullIndices,~] = generate_data(mu1, sig1, [wgt1, wgt2], rRange, ...
    cRange, SAMPLES);

% shuffle the rows of the data
nRows   = size(fullData, 1);        % the number of observations
order   = randperm(nRows);      % the new order of the data (and indices)
data    = [fullData, fullIndices];      % combine the matrices for shuffling
data    = data(order, :);       % shuffle the rows
indices = data(:,end);          % get the shuffled indiced
data    = data(:,1:end-1);      % get the data into its own matrix

fd3 = [fullData, vecnorm(fullData, 2, 2).^2];
figure(6)
bestL.train(fd3, fullIndices);
figure(7)
bestG.train(fullData, fullIndices);

%% Calculate the time required to run
timeEnd = cputime - timeStart;
fprintf('Total runtime: %.1f seconds\n', timeEnd) 