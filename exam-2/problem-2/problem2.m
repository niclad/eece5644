% Nicolas Tedori
% EECE 5644 
% November 22, 2019
% Exam 2 - Problem 2

close all

% add the functions path
addpath(genpath('./functions/'))

% time program
timeStart = cputime;

%% load in the CSV data
%{
Note: Sampling time = col1
      components of nth measurement of y[n] = col2 and col3
%}
% training data
dataTrain = readtable('Q2train.csv');   % read the csv file into a data table
dataTrain = table2array(dataTrain);     % convert to matrix for easy operations

% testing data
dataTest = readtable('Q2test.csv');     % read the csv file into dataTest
dataTest = table2array(dataTest);       % convert to matrix for easier/faster operations

%% Set A and C
% set T
T = 2;
t = (1 / 2) * (T ^ 2);

% A is not correct/finished - come up with a solution here that makes x
% true
% Note that in A, rows 3 and 6 are for CONSTANT and NOISELESS acceleration
A = [ 1, T, t, 0, 0, 0; ...
      0, 1, T, 0, 0, 0; ...
      0, 0, 1, 0, 0, 0; ...
      0, 0, 0, 1, T, t; ...
      0, 0, 0, 0, 1, T; ...
      0, 0, 0, 0, 0, 1 ];

% y = [h, b]' + m[n] = Cx[n] + m[n] therefore C is...
C = [1 0 0 1 0 0];

%% plot the long/lat of training data
figure(1)
dataPlot = sortrows(dataTrain(:,2:end));
plot(dataPlot(:,1),dataPlot(:,2), '.-r')
xlabel('Longitude h(nT)')
ylabel('Latitude b(nT)')
title('Position of an object')

%% display the runtime for the whole program
timeEnd = cputime - timeStart;
fprintf('Total runtime: %0.3f s\n', timeEnd)