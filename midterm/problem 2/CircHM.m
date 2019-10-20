% Nicolas Tedori
% EECE 5644
% Octrober 21, 2019
% Midterm Question 2

%clear all

% [xt; yt] is within this circle:
centerPt = [0,0]; % centered at origin
radius   = 1;     % unit radius

k1 = k_vals(1);
k2 = k_vals(2);
k3 = k_vals(3);
k4 = k_vals(4);
ki = {k1, k2, k3, k4};

% generate a circle
circPts = [0:0.1:(2 * pi)];
circX = cos(circPts);
circY = sin(circPts);

% plot the circle
% plot(circX, circY, '--k')
% axis([-2 2 -2 2])
% axis square
% xlabel('x')
% ylabel('y')

% calculate the true x, y value
xTrue   = unifrnd(-1, 1);           % get a random true x value
yMax    = abs(sin(acos(xTrue)));    % get maximum y based on x
yTrue   = unifrnd(-yMax, yMax);     % get a random true y value bounded by yMax
posTrue = [xTrue; yTrue];



nSigma = 0.3;
sx = 0.25;
sy = 0.25;

xVals  = [-2:0.2:10];
yVals  = [-2:0.2:10];
    
R = GenRange(posTrue, xVals, yVals, nSigma);

x = k4(:, 1);
y = k4(:, 2);
R = GenerateRange(posTrue, k4, 4, nSigma);
Y = sqrt((xTrue - x).^2 + (yTrue - y).^2) + normrnd(0, 0.3);
hyperopts = struct('AcquisitionFunctionName','expected-improvement-plus');
[Mdl,FitInfo,HyperparameterOptimizationResults] = fitrlinear(k4,Y,...
    'OptimizeHyperparameters','auto',...
    'HyperparameterOptimizationOptions',hyperopts);

% z = get_z(xVals, yVals, sx, sy, nSigma, R, length(xVals));
% contour(xVals, yVals, z); hold on
% plot(xTrue, yTrue, '+r')
for K = 1:4
    % generate range measurements
    %R = GenerateRange(posTrue, ki{K}, K, nSigma);
    %plot(ki{K}(:, 1), ki{K}(:, 2), 'ob')
   
end