function Amap = val_mapb(A, At, range, nSig, sx, sy, K)
%VAL_MAP2 Summary of this function goes here
%   Detailed explanation goes here

covar = [sx^2, 0; 0, sy^2];

a = (2*pi*sx*sy)^-1;
b = exp(-(A'*inv(covar)*A)/2);
c = 1;
for i = 1:K
    ca = (2*pi*nSig^2)^-(1/2);
    cb = exp(-(range(i) - norm(At - A))^2/(2*nSig^2));
    c = c * ca * cb;
end

Amap = a*b*c

end

