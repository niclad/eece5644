function valMap = val_map(val, range, sigma, sigmaVal, K)
%VAL_MAP Summary of this function goes here
%   Detailed explanation goes here

% solve summations
numSum = 0;
denSum = 0;
for i = 1:K
    sigmaFrac = 1 / (sigma^2);
    
    numSum = numSum + ((val(i) + range(i)) * sigmaFrac);
    
    denSum = denSum + (sigmaFrac);
end

valMap = -(numSum) / ((1 / (sigmaVal^2)) - K*denSum);

end

