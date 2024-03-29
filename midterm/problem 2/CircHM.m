% Nicolas Tedori
% EECE 5644
% Octrober 21, 2019
% Midterm Question 2

clear all
close all

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



% calculate the true x, y value
hypot   = unifrnd(-1, 1);                       % get a random hypoteneuse
xTrue   = unifrnd(-hypot, hypot);               % get a random true x value
yMax    = abs(hypot*sin(acos(xTrue/hypot)));    % get maximum y based on x
yTrue   = unifrnd(-yMax, yMax);                 % get a random true y value bounded by yMax
posTrue = [xTrue; yTrue];
figure(1)
for i = 1:4
    %plot the circle
    subplot(2, 2, i)
    plot(circX, circY, '--k')
    axis([-2 2 -2 2])
    axis square
    xlabel('x')
    ylabel('y')
    hold on
    
    plot(xTrue, yTrue, '+r')
    plot(ki{i}(:, 1), ki{i}(:, 2), 'ob')
    legend('Circle', 'True pos.', 'Landmarks')
    title('Generated data placed on a circle')
end
hold off

nSigma = 0.3;
sx = 0.25;
sy = 0.25;

xVals  = [-2:0.2:2];
yVals  = [-2:0.2:2];
dataSet = mesh_data(xVals, yVals);

R = GenerateRange(posTrue, dataSet, 441, nSigma);
figure(2)
z = get_z(xVals, yVals, sx, sy, nSigma, R);
contour(xVals, yVals, z); 
%fun = @(t) norm(final_map(dataSet, R, nSigma, sx, sy, length(dataSet)));
%fcontour(fun, [-2 2 -2 2]);
hold on
plot(xTrue, yTrue, '+r')
for K = 1:4
    % generate range measurements
    %R = GenerateRange(posTrue, ki{K}, K, nSigma);
    plot(ki{K}(:, 1), ki{K}(:, 2), 'ob')
   
end
title('MAP estimation objective for -2:2')
xlabel('x')
ylabel('y')
hold off

% DOES NOT WORK
% for i = 4:4
%     k = ki{i};
%     R = GenerateRange(posTrue, k, i, nSigma);
%     zk = get_zk(k, sx, sy, nSigma, R, i);
%     figure(2 + i)
%     contour(k(:, 1), k(:, 2), zk)
%     hold on
%     plot(k(:, 1), k(:, 2), 'ob')
%     plot(xTrue, yTrue, '+r')
%     hold off;
%     
% end