function mapVal = map_val(xi, sx, range, nSig, K)
%MAP_VAL Summary of this function goes here
%   Detailed explanation goes here

nTerm = 0;
for i = 1:K
    nTerm = nTerm + (xi - range(i));
end
nTerm = nTerm / nSig^2;
dTerm = (K/nSig^2) + (1/sx^2);

x = nTerm / dTerm;

% y = 1;
% for i = 1:K
%     if x <= range(i)
%         a = acos(x/range(i));
%     else
%         a = acos(range(i)/x);
%     end
%     b = sin(a);
%     y = y + (range(i) * b);
% end
% y = y / K;

mapVal = x;
end

