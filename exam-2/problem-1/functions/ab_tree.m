function [ mdls, ifW ] = ab_tree(data, m)
%AB_TREE Summary of this function goes here
%   Detailed explanation goes here

%% initialize necessary data
len  = size(data,1);        % number of observations
w    = ones(len, 1) / len;  % initial observation weights
pop  = 1:len;               % population as indices of observations
mdls = cell(m,2);           % save the trained trees & tree weight (a)
ifW  = [w,zeros(len, 1)];   % array for the initial and final weights

%% train the trees

% loop through number of levels:
% train a tree,
% updata values
for n = 1:m
    % get data to use for training
    dataIdx = randsample(pop, len, true, w);    % indices of data to choose from
    dataTrain = data(dataIdx, :);               % theoretically, dataTrain == data == 1
    
    % train the tree using dataTrain
    tempMdl   = train_tree(dataTrain);
    mdls{n,1} = tempMdl;    % save the model for prediction
    
    % get predicted labels
    tempLbl = predict(tempMdl, dataTrain(:,1:end-1));
    
    % find where results are different
    trueness = tempLbl ~= dataTrain(:,end);
    
    % calculate the error
    errN = sum(w .* trueness);  % error numerator
    errD = sum(w);              % error denominator
    err  = errN / errD;         % calculated error
    
    % calculate the classifier weight
    a = log((1 - err) / err);
    mdls{n,2} = a;  % save the weight of the model
    
    
    % update weights
    w = w .* exp(a .* trueness);    % find un-normalized weights
    w = w / sum(w);                 % normalize weights
    if any(w < 0)
        w(w<0)
    end
    
    % save the final weights
    if n == m
        ifW(:,2) = w;
    end
end
end

