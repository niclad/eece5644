function s = logexpsum(x,dim)
%LOGEXPSUM log exp sum trick
%   Detailed explanation goes here

% if nargin == 1, 
%     % Determine which dimension sum will use
%     dim = find(size(X)~=1,1);
%     if isempty(dim), dim = 1; end
% end

% subtract the largest in each dim
y = max(x,[],dim);
s = y+log(sum(exp(x - y),dim));   % TODO: use log1p
i = isinf(y);
if any(i(:))
    s(i) = y(i);
end
end

