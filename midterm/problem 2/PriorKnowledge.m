function probXY = PriorKnowledge(A, sx, sy)
% PriorKnowledge finds the result for P([x;y]) = P(A)
%   A contains the values of x and y -> [x;y]
%   sx and sy are the standard deviations for x and y respectively

cov = [sx^2, 0; 0, sy^2]; % covariance matrix

coeff = 1 / (2 * pi * sx * sy); % the coefficient for the prior
expo  = -((transpose(A) * inv(cov)) * A) / 2; % exponent

probXY = coeff * exp(expo);
end

