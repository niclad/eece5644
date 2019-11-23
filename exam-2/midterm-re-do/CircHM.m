% Nicolas Tedori
% EECE 5644
% November 23 2019
% Exam 1 - Question 2

clear all
close all

% add the path for the functions
addpath(genpath('./functions/'))

% start timing the program 
timeStart = cputime;

%% Generate Data
% [xt; yt] is within this circle:
centerPt = [0,0]; % centered at origin
radius   = 1;     % unit radius

% set landmark locations
k1 = k_vals(1);
k2 = k_vals(2);
k3 = k_vals(3);
k4 = k_vals(4);
ki = {k1, k2, k3, k4};

% generate a circle
circPts = 0:0.1:(2 * pi);
circX = cos(circPts);
circY = sin(circPts);

% calculate the true x, y value
% get the polar coordinates for the true value
trueRadius = rand;          % get a random value between 0 and 1 (our range for the radius)
trueAngle  = rand * 2*pi;   % get a random value between 0 and 2pi (ie the angle from 0, of the point)
[xt,yt]    = pol2cart(trueAngle,trueRadius);    % convert polar to cartesian coordinates
% assign the values to a struct:
truept.x   = xt;
truept.y   = yt;

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

    plot(truept.x, truept.y, '+r')
    plot(ki{i}(:, 1), ki{i}(:, 2), 'ob')
    title(sprintf('%.0f landmarks placed on a circle',i))
end
labels = {'Circle', 'True pos.', 'Landmarks'};
legend(labels,'Location',[0.35,0.01,0.35,0.05],'Orientation','Horizontal')
hold off
saveas(gcf,'images/landmarks','epsc') 

%% plot map objective
sigma = 0.3;

x1 = -2:0.1:2;
x2 = x1;
[xx1, xx2] = meshgrid(x1, x2);
xgrid = [xx1(:), xx2(:)];
gridRange = GenerateRange(truept,xgrid, size(xgrid,1),sigma);

z = mesh_map(xx1,xx2,gridRange,truept,0.1,xgrid,0.25,0.25);

figure(2)
hold on
contourf(xx1, xx2, z, 'ShowText', 'on')
plot(truept.x,truept.y, '+r')
for K = 1:4
    % generate range measurements
    %R = GenerateRange(posTrue, ki{K}, K, nSigma);
    plot(ki{K}(:, 1), ki{K}(:, 2), 'ob')
   
end
axis([-2 2 -2 2])
title('MAP estimation objective w/o landmarks')
xlabel('x')
ylabel('y')
box on
legend({'Contours','Circle', 'True pos.', 'Landmarks'});
hold off
saveas(gcf,'images/init_cont','epsc') 

%% plot map objective for the sensors
x = -2:0.01:2;
y = x;
[xx,yy]=meshgrid(x,y);
valgrid = [xx(:),yy(:)];
sx = 0.25;
sy = sx;
si = 0.1;

figure(3)

for i = 1:4 % testing with 1 lm
    %subplot(2, 2, i)
    figure(i + 2)
    % plot the contours
    rangeMeas = GenerateRange(truept,ki{i},i,si);
    lmMeas    = [ki{i},rangeMeas];
    res = optimal_eq(xx,yy,sx,sy,si,i,lmMeas);
    contourf(x,y,res,'ShowText','on')
    hold on
    %plot the circle
    plot(circX, circY, '--k')
    axis([-2 2 -2 2])
    axis square
    xlabel('x')
    ylabel('y')
    
    plot(truept.x, truept.y, '+r')
    plot(ki{i}(:, 1), ki{i}(:, 2), 'ob')
    title(sprintf('MAP estimate for %.0f sensors',i))
    
    legend({'Contours','Circle', 'True pos.', 'Landmarks'});
    hold off
    imgname = sprintf('images/final_cont_%.0f',i);
    saveas(gcf,imgname,'epsc') 
end
%% display the runtime for the whole program
timeEnd = cputime - timeStart;
fprintf('Total runtime: %0.3f s\n', timeEnd)