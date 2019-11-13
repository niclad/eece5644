function [ mdl, w, b ] = svm_fit_hack(data, y, kern, C)
%SVM_FIT Get SVM values from data and indices
%   Detailed explanation goes here

if isequal(@linear_kernel, kern)
    kerny = 'linear';
else
    kerny = 'rbf';
end

mdl = fitcsvm(data, y, 'KernelFunction', kerny, ...
    'BoxConstraint', C, 'KernelScale', 'auto');

% get values from mdl
w   = mdl.Beta;   % get the slope of the SV
a   = mdl.Alpha;  % get the lagrangian multipliers
b   = mdl.Bias;   % get the intercept of the sv

end

