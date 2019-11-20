function [ labels ] = bag_predict(mdls, data)
%BAG_PREDICT Predict the results for testing data from models
%   data should be m x n without labels

%% 0) initialize return
allLabels = zeros(length(data), length(mdls));

%% 1) loop through models, making predictions
for mdl = 1:length(mdls)
    allLabels(:,mdl) = predict(mdls{mdl}, data);
end

%% 2) decide label by vote
labels = mode(allLabels,2);     % get the mode of every row
end

