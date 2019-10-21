function mapVal = map_val(xi, sx, range, nSig, K)
%MAP_VAL Summary of this function goes here
%   Detailed explanation goes here

% i have no fucking clue what im doing here
sumterm = 0;
for i = 1:K
    sumterm = sumterm + (range(i)-xi(i))/(nSig^2);
end

co = (1/nSig^2 + 1/sx^2)^-1;

x = sumterm * co;

mapVal = x;
end

