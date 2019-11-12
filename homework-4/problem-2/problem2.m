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

%% Set up cross-validation data


%% Calculate the time required to run
timeEnd = cputime - timeStart;
fprintf('Total runtime: %.1f seconds\n', timeEnd) 