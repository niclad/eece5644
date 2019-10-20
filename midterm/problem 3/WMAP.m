function wMap = WMAP(gamma, I, D, sigma, N)
%WMAP get the Wmap from the grossly large eqn below
% gamma^2*I will create a 4x4 matrix where Ijj is equal to all other Ijj
% therefore gamma^2*I(j, j) = gamma^2 = parameter variance

wMap      = zeros(1, 4);                            % initialize the MAP estimate parameter vector
funcTerms = {@(x) x^3, @(x) x^2, @(x) x, @(x) 1};   % array of terms as anonymous functions
G = gamma^2;                                        % gamma^2 (AKA parameter variance)

for j = 1:length(wMap)
    % get the sum of the numerator and denominator terms
    nSum = 0;   % numerator term
    dSum = 0;   % denominator term
    for i = 1:N
        xij  = funcTerms{j}(D(i, 1));
        yi   = D(i, 2);
        nSum = nSum + (yi * xij);
        dSum = dSum + (xij^2);
    end
    
    % calculate the numerator and denominator terms
    nTerm = (1/(sigma^2)) * nSum;               % numerator term
    dTerm = (1/G) - ( (1/(sigma^2)) * dSum);    % denominator term
    
    % add the value to the wMap vector
    wMap(j) = nTerm / dTerm;
    
end
end

