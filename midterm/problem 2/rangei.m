function [ri, probRA] = rangei(Ai, At, stdev)
%rangei calcualtes the range from ri = dTi + ni and the likelihood
%   dTi = ||At - Ai||, where A = [x; y], which is the true position or the
%   position for i.
%   ni = noise generated from normrnd(0, stdev)

% terms for ri
dTi = norm(At - Ai);     % calculate the normal for dTi
ni  = normrnd(0, stdev); % calculate measurement noise
ri  = dTi + ni;          % return ri -> ni = ri - dTi

% terms for likelihood
coeff  = 1 / sqrt(2 * pi * stdev^2);      % coefficient for e
expo   = -((ri - dTi)^2) / (2 * stdev^2); % exponent for e
probRA = coeff * exp(expo);               % return the likelihood
end

