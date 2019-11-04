function y = logmvnpdf(x, mu, var)
d = size(x,1);
x = x - mu;
[u,p]= chol(var);
if p ~= 0
    error('ERROR: Sigma is not PD.');
end
Q = u'/x;
q = dot(Q,Q,1);  % quadratic term (M distance)
c = d*log(2*pi)+2*sum(log(diag(u)));   % normalization constant
y = -(c+q)/2;
end

