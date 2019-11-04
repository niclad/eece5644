function [ avgComps ] = mcomponents(c, k, nc)
%MCOMPONENTS get the averages of all the components
%   @param c is the parameters for all k folds
%   @param k is the number of folds
%   @param nc is the number of GMM components

% split values for easier access
mu     = c(:, 1);
cov    = c(:, 2);
wgt    = c(:, 3);
newMu  = cell(1, nc);
newCov = cell(1, nc);
newWgt = cell(1, nc);

% loop computing averages
for n = 1:nc
    tempMu  = [0, 0];
    tempCov = zeros(2);
    tempWgt = 0;
    for i = 1:k
        tempMu  = tempMu  +  mu{i}{n};
        tempCov = tempCov + cov{i}{n};
        tempWgt = tempWgt + wgt{i}{n};
    end
    newMu{n}  = tempMu  / k;
    newCov{n} = tempCov / k;
    newWgt{n} = tempWgt / k;
end

avgComps{1, 1} =  newMu;
avgComps{1, 2} = newCov;
avgComps{1, 3} = newWgt;

end

