function [ labels ] = ab_predict(mdls,data)
%AB_PREDICT Summary of this function goes here
%   Detailed explanation goes here

%% 0) initialize return
allLabels = zeros(length(data), length(mdls));

%% 1) loop through models, predicting results
for m = 1:size(mdls,1)
    a = mdls{m,2};  % model weight
    allLabels = a .* predict(mdls{m,1}, data);
end

%% 2) get the labels
labels = sum(allLabels,2);
labels = labels ./ labels(1);

end

