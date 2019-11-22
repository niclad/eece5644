% Nicolas Tedori
% EECE 5644
% Octrober 21, 2019
% Midterm Question 2

clear all
close all

%% Generate Data
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

%% plot the different set-ups
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
    title('Generated data placed on a circle')
end
labels = {'Circle', 'True pos.', 'Landmarks'};
legend(labels,'Location',[0.35,0.01,0.35,0.05],'Orientation','Horizontal')
hold off

%% plot map objective
sigma = 0.3;

x1 = -2:0.05:2;
x2 = x1;
[xx1, xx2] = meshgrid(x1, x2);
xgrid = [xx1(:), xx2(:)];
gridRange = GenerateRange(posTrue',xgrid, size(xgrid,1),sigma);

z = mesh_map(xx1,xx2,gridRange,posTrue,0.1, xgrid, 0.25, 0.25);

figure(2)
hold on
contour(xx1, xx2, z)
plot(xTrue, yTrue, '+r')
for K = 1:4
    % generate range measurements
    %R = GenerateRange(posTrue, ki{K}, K, nSigma);
    plot(ki{K}(:, 1), ki{K}(:, 2), 'ob')
   
end
axis([-2 2 -2 2])
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