function [solu, b, w] = svm_fit(data, y, kern, C)
%SVM_FIT Get SVM values from data and indices
%   Detailed explanation goes here

[nSamples, nFeatures] = size(data);

G = gram_mat(data, kern);

% million dollar question:
% WILL! THIS! WOOOOOOOOOORK?!?!?
%H   = (y * y') * G;
H = (data * data') .* (y * y');
f = ones(nSamples,1);
A = -eye(nSamples);
a = zeros(nSamples, 1);
B = [y';zeros(nSamples-1, nSamples)];
b = zeros(nSamples, 1);

% find the lagrangian multipliers
solu = quadprog(H+eye(nSamples)*0.001, f, A, a, B, b);
a    = solu;

% find the support vectors (SVs will have a ~= 0)
sv   = a > 1e-5;
ind  = sv;
a    = a(ind == 1);
sv   = data(ind == 1,:);
y_sv = y(ind == 1);

% calc W
w = sum((a .* y_sv) .* sv);

% intercept
b = 0;
for n = 1:length(a)
    b = b + y_sv(n);
    b = b - sum(a .* y_sv .* G(ind(n),sv));
end
b = b / length(a);


end

