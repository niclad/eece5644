function [ mdl ] = train_tree(data)
%TRAIN_TREE Train a tree classifier using Matlabs built-in fitctree
%   data is an m-by-n matrix where column n are the class labels
x = data(:,1:end-1);    % get observations
y = data(:,end);        % get class labels

% using fitctree, train a classifier
mdl = fitctree(x, y, ...
    'MaxNumSplits', 11, 'PredictorSelection', 'allsplits', ...
    'PruneCriterion', 'impurity', 'SplitCriterion', 'gdi');

end

