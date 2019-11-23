function R = GenerateRange(posTrue, posGen, K, sigma)
%GENERATERANGE Summary of this function goes here
%   Detailed explanation goes here

posTrue = [posTrue.x,posTrue.y];
R = repmat(-1, 1, K);   % generate a matrix of all -1
posi = posTrue - posGen;
posi = vecnorm(posi, 2, 2);
R = posi + (sigma .* randn(K,1));

while any(R < 0) % while any element in R is less than 0
    
    lt0 = R < 0;
    
    for i = 1:length(lt0)
        tempR = -1;
        if lt0(i) ~= 1
            continue
        else
            while tempR < 0
                tempR = vecnorm((posTrue - posGen(i,:)), 2, 2) + ...
                    (sigma * randn(1));
            end
            R(i) = tempR;
        end
    end
    
end

end

