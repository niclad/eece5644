function [ ROC, tau] = estimate_roc(discrScore, label)
%ESTIMATE_ROC Summary of this function goes here
%   Detailed explanation goes here

% Generate ROC curve samples
Nc = [length(find(label == 2)),length(find(label == 1))];
sortedScore = sort(discrScore,'ascend');
tau = [sortedScore(1)-1, ...
    (sortedScore(2:end)+sortedScore(1:end-1))/2,sortedScore(end)+1];

% thresholds at midpoints of consecutive scores in sorted list
for k = 1:length(tau)
 decision = (discrScore >= tau(k));
 ind10 = find(decision==1 & label==2); p10 = length(ind10)/Nc(1); % probability of false positive
 ind11 = find(decision==1 & label==1); p11 = length(ind11)/Nc(2); % probability of true positive
 ROC(:,k) = [p10;p11];
end

end

