%% Nicolas Tedori
%  produces N samples of independent and identically ...
% distributed (iid) n-dimensional random vectors
% IN:
% N = samples
% n = dimension
% mu = mean
% sigma = variance
% OUT:
% samplesN = N number iid n-dimensional random vectors stored in a vector

%% function for problem
function [samplesN] = q5p3(N, n, mu, sigma)
    
    % initialize a call array of size N
    samplesN = cell(1, N);
    
    % linear transform coeffs
    % according to matlab this is true:
    % syms A s; solve((A*transpose(A)) - s == 0, A)
    A = sqrtm(sigma);    % A = nxn matrix therefore sigma must nxn
    b = mu;             % b = mu is a row vector

    % loop through N samples adding n-dim vectors
    % Note :randn(m, n) generates a vector of size mxn from N(0, I)
    for i = 1:1:N
        x = A*randn(n,1) + b   % transform column vector by x = Az + b
        samplesN{1, i} = x;     % add random vector xi to samplesN
    end
    
    samplesN = cell2mat(samplesN); % convert samplesN to a matrix.
    % each column will be one random vector, xi

end
