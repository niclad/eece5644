% Nicolas Tedori
% EECE 5644 
% November 22, 2019
% Exam 2 - Problem 2

close all
clear all

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
C = [1 0 0 0 0 0; ...
     0 0 0 1 0 0];

%% plot the long/lat of training data
figure(1)
%dataPlot = sortrows(dataTrain(:,2:end));
dataPlot = dataTrain(:,2:3);
plot(dataPlot(:,1),dataPlot(:,2), 'x:r', 'LineWidth', 1)
xlabel('Longitude h(nT)')
ylabel('Latitude b(nT)')
title('Position of an object')
grid on
saveas(gcf, 'images/trajectory', 'epsc')

%% Kalman filter for {xe[n]}
% testing the finction to make sure reuslts are expected (for arbitrary K
% and S)
K = -0.10;      % arbitrary K value
S = -4;         % arbitrary S value
Q = eye(6) * K; % calculate Q
R = eye(2) * S; % calculate R
y = dataTrain(:,2:end);
[xen,ye] = kalman_filter(A,C,K,S,zeros(6,1),y);

% test plot - results are close to what i expect but nothing is "filtered"
figure(2)
plot(dataPlot(:,1), dataPlot(:,2), 'b', ye(:,1),ye(:,2),'--r')

%% K and S cross validate
% mesh grid of values
K = -4:0.1:4;   % range of Ks to test
S = -4:0.1:4;   % range of Ss to test
[kk,ss] = meshgrid(K,S);    % generate a meshgrid
coefs   = [kk(:),ss(:)];    % align the values
results = zeros(size(coefs,1),1);
x0      = zeros(6,1);       % initial x to test

% loop thorugh the values and determine the one with the lowest average
for i = 1:size(coefs,1)
    k = coefs(i,1);
    s = coefs(i,2);
    
    % k and s == 0 causes computational issues. there is no result, so skip
    % 'em
    if k == 0 && s == 0
        continue
    end
    %fprintf('current K = %.2f\tS = %0.2f\n',k,s)
    
    % get filtered result
    [tempx,tempye] = kalman_filter(A,C,k,s,x0,y);   
    
    % interpolate as filtered result for unknown times
    estLoc = my_interp(tempye,dataTrain(:,1),dataTest(:,1));
    
    % save cross validation resultf
    results(i) = my_cv(estLoc, tempye);
end

% remove non-zero elements to ensure there is some variance
if any(results == 0)
    results = nonzeros(results);
end

[~,mi] = min(results);  % get the best result (from cv computation)
best.k = coefs(mi,1);   % set k
best.s = coefs(mi,2);   % set s
fprintf('Best K = %.2f\tS = %0.2f\n',best.k,best.s) % display results
% don't believe this result is correct, but final graph looks good, so I';m
% not sure.

%% plot all relevant information
figure(3)
% plot training data
plot(dataTrain(:,2),dataTrain(:,3),'xr')
hold on
% plot testing data 
plot(dataTest(:,2),dataTest(:,3), 'ob')

% get result data
[~,nye] = kalman_filter(A,C,best.k,best.s,zeros(6,1),y);
plot(nye(:,1),nye(:,2),'LineStyle', '-', 'Marker', '+', 'Color', [0.6115,0,0.3885])
nestLoc = my_interp(nye,dataTrain(:,1), dataTest(:,1));
plot(nestLoc(:,1),nestLoc(:,2),'--*k', 'MarkerSize',3)
grid on
title(sprintf('Kalman filter results and interpolated results\nBest K=%.2f,S=%.2f',best.k,best.s))
xlabel('Longitude h')
ylabel('Latitude b')
legend({'Training data', 'Testing data', 'Filter results','Interp. results'})
saveas(gcf, 'images/results', 'epsc')

%% display the runtime for the whole program
timeEnd = cputime - timeStart;
fprintf('Total runtime: %0.3f s\n', timeEnd)