% Nicolas Tedori
% EECE 5644
% October 21, 2019
% Midterm - Question 3
clear all
tic
% number of samples
N = 10;

%% determine Wtrue (wt): will give x as a 1 by 3. 
% 3 roots given y = 3rd order polynomial
xRoots = unifrnd(-1, 1, 1, 3);

% calculate true parameters from x:
syms x
polyEqn = (x - xRoots(1)) * (x - xRoots(2)) * (x - xRoots(3));
wt      = coeffs(polyEqn, 'All'); % wt = Wtrue values from most to least deg
% note: wt(0) will always be 1 based on how polyEqn works (no coeff for
% x's)

% find v
% define sigma as a constant
sigma = 0.2; % sqrt(var)

% define gamma
B = 5;
numPts = 10;
gamma  = logspace(-B, B, numPts); % generates numPts points
I      = eye(4);

% Generate Samples
D = GenerateSamples(wt, sigma, N);

%% Get wMap for all gamma
GwMaps = cell(numPts, 1);   % cell array for MAP estimates for each gamma
GL2    = zeros(numPts, 1);  % array for L2 error values

for i = 1:numPts
    GwMaps{i} = WMAP(gamma(i), I, D, sigma, N);
    GL2(i)    = SqrError(wt, GwMaps{i});
end

%% Perform expm number of experiments (THIS WILL TAKE A WHILE TO RUN)
expm    = 100;                  % number of experiments to perform
L2Vals  = zeros(expm, numPts);  % initialize vector to hold L2^2 vals
wPriors = zeros(expm, numPts);  % store the calculated priors from P(w)

fprintf('Running experiments! Please be patient!\n')

for g = 1:numPts
    G = gamma(g);   % get the gamma value
    for ex = 1:expm
        DEx              = GenerateSamples(wt, sigma, N);     % generate samples for this experiment
        wMap             = WMAP(G, I, DEx, sigma, N);         % find w_map for these samples
        L2Vals(ex, g)    = SqrError(wt, wMap);                % calculate the squared L2 error
        wPriors(ex, g)   = Pw(wMap, G, I);                    % calculate the prior for w_map
    end
end

fprintf('Experiments finished! Plotting...\n')

% define indices for the min, 25, med, 75, and max values
Lmin =  1;
L25  = 25;
Lmed = 50;
L75  = 75;
Lmax = expm;

% sort L2s
for g = 1:numPts
    [~, L2Idx] = sort(L2Vals(:, g));    % sort the L2 Values
    L2Sorted = [L2Vals(L2Idx(Lmin), g), L2Vals(L2Idx(L25), g), L2Vals(L2Idx(Lmed), g), L2Vals(L2Idx(L75), g), L2Vals(L2Idx(Lmax), g)];
    PwSorted = [wPriors(L2Idx(Lmin), g), wPriors(L2Idx(L25), g), wPriors(L2Idx(Lmed), g), wPriors(L2Idx(L75), g), wPriors(L2Idx(Lmax), g)];
    plotName = sprintf('plot%1.0f', g);
    figure(g);
    plot(L2Sorted, PwSorted, '-b')
    ylabel('P(w)')
    xlabel('||w_{T}-w_{map}||_2^2')
    str = sprintf('$P(w)$ as Squared-Error Increases. gamma = %4.3E.', gamma(g));
    title(str)
    hold on
    scatter(L2Sorted, PwSorted, 'rx')
    saveas(gcf, strcat('images/gammaCurve_', plotName), 'epsc')
    hold off
    
end

fprintf('Complete!\n')

toc
% curr time ~ 300s
   