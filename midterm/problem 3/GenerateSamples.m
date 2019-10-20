function D = GenerateSamples(wt, sigma, N)
%GENERATESAMPLES generate noise, v, x values, xVals, and iid N-samples D

% generate noise from N(0, sigma^2)
v = zeros(10, 1);   % init v vector
for i = 1:N  % loop through v 
    v(i) = normrnd(0, sigma); % generate a random noise value for v
end

% generate D
D = zeros(10, 2); % init D -- D(:, 1) = x; D(:, 2) = y
xVals = unifrnd(-1, 1, 10, 1); % randomly get 10 x values from uniform dist
for i = 1:N  % loop through D adding/generating values
    % set the x value
    D(i, 1) = xVals(i);
    
    % get the y value from x value, wt, and v values
    D(i, 2) = my_poly(wt, xVals(i), v(i));
end

end

