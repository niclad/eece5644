function [ mu, covm, wgt ] = M_Step_copy(x, prob, nc)
%M_STEP Update component parameters
%   Detailed explanation goes here

ptNum   = size(x, 1);
compSum = zeros(1, nc);
mu      = zeros(1, 2, nc);
covm    = zeros(2, 2, nc);
wgt     = zeros(1, 1, nc);
prob;

compSum = sum(prob, 1);

%get component means (pretty sure this is incorrect)
% for n = 1:ptNum
%     for k = 1:nc
%         mu(:,:,k) = (1 / compSum(k)) * sum(prob(:, k) * x(n, :));
%     end
% end

for k = 1:nc
    for n = 1:ptNum
        mu(:,:,k) = (1 / compSum(k)) * sum(prob(:, k) .* x);
    end
end

compSum;
% get component covariances
% VERY IMPORTANT NOTE: This is mathematically sound, HOWEVER, if the values
% used in this loop are too small, Sigma will not be PSD.
for n = 1:ptNum
    for k = 1:nc
        covm(:,:,k) = covm(:,:,k) + (prob(n, k) * ...
            ((x(n, :) - mu(:,:,k))' * (x(n, :) - mu(:,:,k))));
    end
end

% for k = 1:nc
%     covm(:,:,k) = cov(x .* repmat(prob(:, k), 1, 4));
% end
covm;
% Get the corrected covariance
for k = 1:nc
    covm(:, :, k) = covm(:, :, k) / compSum(k);     % correct Sigma
    min_eig       = min(real(eig(covm(:,:,k))));    % get smallest eigval
    
    % test the smallest eig val to ensure that Sigma is PSD
    % (due to rounding errors)
    % essentially this adds a very small value to Sigma to make sure that
    % Matlab doesn't think it's not positive-definite
    % probably a better way to do this...?
    if min_eig == 0 || (min_eig > 0 && min_eig < 1e-12)
        covm(:,:,k) = covm(:,:,k) - 10 * (min_eig - 1e-12) * eye(2);
    elseif min_eig < 0
        covm(:,:,k) = covm(:,:,k) - 10 * min_eig * eye(2);
    end
    
end

% get weights
for k = 1:nc
    wgt(:,:,k) = compSum(k) / ptNum;
end

end

