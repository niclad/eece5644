function [ w0, pE_min, tn_lda, fp_lda, fn_lda, tp_lda, roc, discr_lda, t ] = f_lda(data, classInd, obsNum)
%F_LDA Fisher LDA on given data
%   Detailed explanation goes here

% vector of cumsum of observations
cumObs = cumsum(obsNum);

% get data class-wise
class1 = data(1:cumObs(1),:);               % class '-' data
class2 = data(cumObs(1) + 1:cumObs(2),:);   % class '+' data

% get mean for classes
mu1 = mean(class1)';    % mean for '-' data
mu2 = mean(class2)';    % mean for '+' data

% covariance matrices
sig1 = cov(class1);     % covariance for '-' data
sig2 = cov(class2);     % covariance for '+' data

% within class scatter
sigW = sig1 + sig2;

% between-class scatter
sigB = (mu1 - mu2) * (mu1 - mu2)';

% compute LDA projection
proj = sigW \ sigB;

% compute projection vector
[v, d] = eig(proj);

% determine correct projection vector
if d(1,1) > d(2,2)
    w0 = v(:,1);
else
    w0 = v(:,2);
end

% data mu as a 3-d vector
mu = cat(3, mu1', mu2');

% data projected onto w0
y_lda = w0' * data';

% all of class '-' is in negative region
w0 = sign(mean(y_lda(find(classInd == 1))) - ...
    mean(y_lda(find(classInd == 2)))) * w0;

% get the discriminant score
discr_lda = sign(mean(y_lda(find(classInd == 1))) - ...
    mean(y_lda(find(classInd == 2)))) * y_lda;


% estimate ROC curve
[roc, t] = roc_curve(data, classInd, discr_lda);
%[roc, t] = estimate_roc(discr_lda, classInd');
%roc = roc';
roc = sortrows(roc, 'descend');

% p(error) of lda for different threshold vals
pE_lda = [roc(:, 1), 1 - roc(:,2)] * ...
    [sum(classInd == 1), sum(classInd == 2)]' / 999; % 999 comes from SAMPLES in problem2.m (ie # samples generated)

% minimum error
pE_min = min(pE_lda);

ind = find(pE_lda == pE_min);
deci_lda = (discr_lda >= t(ind(1))); % smalles min-error threshold
tn_lda = find(deci_lda == 0 & classInd' == 2);    % true negative
fp_lda = find(deci_lda == 1 & classInd' == 2);    % false positive
fn_lda = find(deci_lda == 0 & classInd' == 1);    % false negative
tp_lda = find(deci_lda == 1 & classInd' == 1);    % true positive

end