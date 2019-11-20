function [ g ] = gini_impurity(subset)
%GINI_PURITY Calculate the Gini purity for this data set
%   Note: not sure how to determine the splits

% get data frequency
y     = subset(:,end);
yfreq = tabulate(y);
nd    = size(yfreq,1);
pC    = zeros(1,nd);

% get the number of elements for each class
for c = 1:nd
    % get priors for a class
    pC(c) = yfreq(c,3) / 100;
end

% calculate the gini impurity
pC = pC .^ 2;


g = 1 - sum(pC);

end

