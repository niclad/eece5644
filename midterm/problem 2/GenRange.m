function R = GenRange(posTrue, xVals, yVals, nSigma)
%GENERATERANGE Summary of this function goes here
%   Detailed explanation goes here

R = repmat(-1, 1, length(xVals)*length(yVals));   % generate a matrix of all -1

n = 1;
while any(R < 0) % while any element in R is less than 0
    for i = 1:length(xVals)
        x  = xVals(i);
        
        for j = 1:length(yVals)
            y = yVals(i);
            posi = [x; y]; 
            R(n) = norm(posTrue - posi) + normrnd(0, nSigma); % calculate range measurement
    
            if ~(R(n) < 0) % is R at i IS NOT < 0
                n = n + 1; % increase i
            end
        end
    end
    
end
end

