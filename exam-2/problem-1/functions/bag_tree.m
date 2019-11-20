function [ mdls ] = bag_tree(data,m)
%BAG_TREE Create m tree classifiers from randomly sampled data from data
%   All of data is used to sample from. i.e. remove testing data
%   before-hand

%% 0) initialize relevant matrices
mdls = cell(m,1);   % cell array containing tree models

%% 1) train trees

% loop through datasets, generating trees
for t = 1:m
    % generate data
    dataTrain = bag_data(data);
    
    % train a tree classifier
    tempMdl = train_tree(dataTrain);
    
    % store tree classifer in a cell
    mdls{t} = tempMdl;
end

end

