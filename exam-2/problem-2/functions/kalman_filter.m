function [ xen, ye ] = kalman_filter(A, C, K, S, x0n, y)
%KALMAN_FILTER Kalman Filtering on time-domain item
%   x0n is initial estimate
%   Q = K*I
%   R = S*I

% initialize values
Q   = eye(6) .* K;
R   = eye(2) .* S;
P   = Q;
xen = x0n;
xenMat = zeros(size(y,1), max(size(x0n)));
ye  = zeros(size(y,1), 2);

for i = 1:size(y,1)   
    % Time update
    xen = A*xen;        % x[n+1|n]
    P   = A*P*A' + Q;   % P[n+1|n]
    
    % Measurement update
    Mn   = P*C' / (C*P*C' + R);         % Kalman Gain
    xen = xen + Mn*(y(i,:)' - C*xen);   % x[n|n]
    P   = (eye(6) - Mn*C)*P;            % P[n|n]
    %xenMat(i,:) = xen;
    
    ye(i,:) = C*xen;
end

end

