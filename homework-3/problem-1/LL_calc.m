function [ ll ] = LL_calc(x, mu, var, alpha, nc)
%LL_CALC Pretty much does the same thing as E_Step(...)
%   Detailed explanation goes here

ptNum      = size(x, 1);
parts      = zeros(ptNum, nc);
postVals   = zeros(ptNum, nc);

for n = 1:ptNum
    for i = 1:nc
        % likelihood for this x
        parts(n, i) = mvnpdf(x(n, :), mu(:,:,i), var(:,:,i)) * ...
            alpha(:,:,i);
    end
end

partSum = sum(parts, 2); % sum all the columns to normalize data

for n = 1:ptNum
    for i = 1:nc
        postVals(n, i) = parts(n, i) / partSum(n);
    end
end

llVals = log(partSum);
ll     = sum(llVals);

end

