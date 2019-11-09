% Nicolas Tedori
% EECE 5644 
% November 14, 2019
% Homework 4 - Problem 1

% time program
timeStart = cputime;

%% Load the images
planeImg = imread('3096_colorPlane.jpg');	% load plane image
birdImg  = imread('42049_colorBird.jpg');	% load bird image

% NOTE: imread() outputs an m x n x 3 matrix with the color values
% (presumably r, g, b) -- according to my test, that is the case

% planeImg(:,:,1) = 0;      % red
% planeImg(:,:,2) = 0;      % green
% planeImg(:,:,3) = 255;    % blue
% imshow(planeImg)          % "plot" the image

%% Get the data in the format required
[planeNorm, planeReg] = image_normalizer(planeImg);

%% Calculate the time required to run
timeEnd = cputime - timeStart;
fprintf('Time to run: %.0f seconds\n', timeEnd) 