function R = GenerateRange(posTrue, posGen, K, nSigma)
%GENERATERANGE Summary of this function goes here
%   Detailed explanation goes here

R = repmat(-1, 1, K);   % generate a matrix of all -1

i = 1;
while any(R < 0) % while any element in R is less than 0
    posi = [posGen(i, 1); posGen(i, 2)]; 
    R(i) = norm(posTrue - posi) + normrnd(0, nSigma); % calculate range measurement
    
    if ~(R(i) < 0) % is R at i IS NOT < 0
        i = i + 1; % increase i
    end
    
end

end

