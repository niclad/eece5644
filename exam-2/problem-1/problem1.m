% Nicolas Tedori
% EECE 5644 
% November 22, 2019
% Exam 2 - Problem 1

close all

% add the functions path
addpath(genpath('./functions/'))

% time program
timeStart = cputime;

%% load in the CSV data
data = readtable('Q1.csv');     % read the csv file into a data table
data = table2array(data);       % convert to matrix for easy operations

%% plot the initial data
gscatter(data(:,1), data(:,2), data(:,3), 'rk', 'ox')   % plot data as a grouped scatter plot

newData = data(data(:,1) >= -1, :);
newData = newData(newData(:,1) <= 1,:);
newData = newData(newData(:,2) >= -1,:);
newData = newData(newData(:,2) <= 1,:);
%hold on
%scatter(newData(:,1),newData(:,2), '.b');

xlabel('x1 (attribute 1)')
ylabel('x2 (attribute 2)')
title('Data with correct class labels')     % plot title
grid on;                                    % view grid lines
axis([-4 4 -4 4])
saveas(gcf,'images/correct_data','epsc')    % save firgure as a colored eps file
close

%% manually holdout data
% first 10% of data is used for testing
% rest for training
nObs    = size(data,1);         % the number of observations in the data (should be 1000)
testLen = floor(0.1 * nObs);    % get 10% of the total length

% partition the data
dataTest  = data(1:testLen,:);      % for testing data, get observations at rows 1 through testLen, and all columns
dataTrain = data(testLen+1:end,:);  % get the rest of the data for training

%% Regular tree (no bagging, no boosting)
treeStart = cputime;
% treeMdl = fitctree(dataTrain(:,1:end-1), dataTrain(:,end), ...
%     'MaxNumSplits', 11, 'PredictorSelection', 'allsplits', ...
%     'PruneCriterion', 'impurity', 'SplitCriterion', 'gdi');
treeMdl = train_tree(dataTrain);

%% plot tree, boundaries, and confusion matrix
before = findall(groot,'Type','figure'); % Find all figures

% view the decision tree
view(treeMdl,'Mode','graph')    % no customization options
% even a pain to save as a file
after = findall(groot,'Type','figure');
h = setdiff(after,before); % Get the figure handle of the tree viewer
saveas(h,'images/default_tree_view','pdf')

% get tree cuts
[x1, x2] = get_cuts(treeMdl);

% plot the data and boudaries
figure(1)

hold on
box on
plot_boundary(treeMdl, data);
gscatter(data(:,1), data(:,2), data(:,3), 'rk', 'ox')
legend off
xlabel('x1 (attribute 1)')
ylabel('x2 (attribute 2)')
title('Decision tree boundaries')     % plot title
legend({'-1 boundary', '+1 boundary', '-1', '+1'})
grid on
axis([-4 4 -4 4])
hold off
box on
saveas(gcf,'images/default_tree','epsc')    % save firgure as a colored eps file

% confusion matrix
predictedLabels = predict(treeMdl, dataTest(:,1:end-1));    % get predicted labels
trueLabels = dataTest(:,end);                   % get the true labels
C = confusionmat(trueLabels, predictedLabels);  % get confusion matrix
confusionchart(C);                              % display the confusion matrix
title({'Test data confusion matrix for a','tree w/o boosting or bagging'})
saveas(gcf,'images/default_confmat','epsc')     % save firgure as a colored eps file

% display time to generate the tree
timeDefTree = cputime - treeStart;
fprintf('Default tree time: %0.3f s\n', timeDefTree)

%% self implementation of tree - irrelevant
% my_tree = build_tree(dataTrain, 4);
% print_tree(my_tree, "");
% dataClassified = dataTest;
% 
% for i = 1:size(dataTest,1)
%     result = cell2mat(classify(dataTest(i,:), my_tree));
%     [~, bestIdx] = max(result(:,2));
%     bestClass = result(bestIdx,1);
%     dataClassified(i,end) = bestClass;
% end
% figure(2)
% gscatter(dataTrain(:,1), dataTrain(:,2), dataTrain(:,3), 'rk', 'ox')
% hold on
% gscatter(dataTest(:,1), dataTest(:,2), dataTest(:,3), 'mg', 'xo')

%% bagging decision tree
treeStart = cputime;
% train trees
treeMdls   = bag_tree(dataTrain,7);

% predict results for training data
predLabels = bag_predict(treeMdls,dataTest(:,1:end-1));

% display confusion matrix
trueLabels = dataTest(:,end);                   % get the true labels
C2 = confusionmat(trueLabels, predLabels);  % get confusion matrix
confusionchart(C2);                              % display the confusion matrix
title({'Test data confusion matrix','for a tree w/ bagging'})
saveas(gcf,'images/bag_confmat','epsc')     % save firgure as a colored eps file

% plot the data and boundaries
plot_bag_bound(treeMdls);
hold on
gscatter(data(:,1), data(:,2), data(:,3), 'rk', 'ox')
legend off
xlabel('x1 (attribute 1)')
ylabel('x2 (attribute 2)')
title('Decision tree boundaries for Bagging')     % plot title
legend({'-1 boundary', '+1 boundary', '-1', '+1'})
grid on
axis([-4 4 -4 4])
hold off
saveas(gcf,'images/bag_tree','epsc')    % save firgure as a colored eps file

% display time to generate the tree
timeBagTree = cputime - treeStart;
fprintf('Bagging tree time: %0.3f s\n', timeBagTree)

%% adaboost decision tree
treeStart = cputime;
% train the AdaBoost tree classifier
[abMdls, ifW] = ab_tree(dataTrain,7);

% classify testing data
abPred = ab_predict(abMdls, dataTest(:,1:end-1));

% display confusion matrix
trueLabels = dataTest(:,end);                   % get the true labels
C2 = confusionmat(trueLabels, predLabels);      % get confusion matrix
confusionchart(C2);                             % display the confusion matrix
title({'Test data confusion matrix','for a tree w/ boosting'})
saveas(gcf,'images/ab_confmat','epsc')         % save firgure as a colored eps file

% plot the data and boundaries
plot_bag_bound(abMdls);
hold on
gscatter(data(:,1), data(:,2), data(:,3), 'rk', 'ox')
legend off
xlabel('x1 (attribute 1)')
ylabel('x2 (attribute 2)')
title('Decision tree boundaries for Boosting')     % plot title
legend({'-1 boundary', '+1 boundary', '-1', '+1'})
grid on
axis([-4 4 -4 4])
hold off
saveas(gcf,'images/ab_tree','epsc')    % save firgure as a colored eps file

% display time to generate the tree
timeAbTree = cputime - treeStart;
fprintf('AdaBoost tree time: %0.3f s\n', timeAbTree)

%% display the runtime for the whole program
timeEnd = cputime - timeStart;
fprintf('Total runtime: %0.3f s\n', timeEnd)
