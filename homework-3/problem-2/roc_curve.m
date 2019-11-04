function [ roc, t ] = roc_curve(data, classIndex, score, mu, sig)
%ROC_CURVE Get x and y values for ROC curve for first class label ('-').
%   Detailed explanation goes here

% calculate scores
%score = mvnpdf(data, mu', sig);

% calculate ROC curve
[xROC, yROC, t, ~] = perfcurve(classIndex, score', 1);
roc = [xROC, yROC];

end

