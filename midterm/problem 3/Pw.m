function pW = Pw(wMap,gamma, I)
%PW Summary of this function goes here

coeff = 1 / sqrt((2*pi)^4 * det(gamma^2 * I));
euc = exp(-(wMap * inv(gamma^2 * I) * transpose(wMap))/2);
pW = coeff * euc;

end

