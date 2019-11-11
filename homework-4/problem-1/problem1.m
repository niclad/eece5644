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
[planeNorm, ~] = image_normalizer(planeImg);
planeNorm(:,2) = flip(planeNorm(:,2));

%% Run K-Means

maxIter = 75;   % define a maximum iterations incase convergence is never reached

colors  = {'.b','.k','.r','.g','.y','.m','.c','.w'}; % colors used for plotting

for k = 2:5
    centroids = init_centroids(planeNorm, k);
    prevCentr = centroids;
    n = 1;
    while ~isequal(prevCentr, centroids) || (n < maxIter)
        indices   = closest_centroids(planeNorm, centroids, k);
        centroids = compute_centroids(planeNorm, indices, k);
        prevCentr = centroids;
        n         = n + 1;
    end
    
    % plot the image for the k
    subplot(2, 2, k-1);
    for i = 1:k
        % partition data into easily-accessible data mat
        plot_data = planeNorm(indices == i, 1:2);
        % plot the data mat
        plot(plot_data(:,1), plot_data(:,2), colors{i}, 'MarkerSize', 1);
        hold on
    end
    title(sprintf('K-means plane jpg for k=%.0f', k));
    xlabel('x-pixels')
    ylabel('y-pixels')
    
end

%% Plot the plane image
color1 = planeNorm(indices == 1, 1:2);
color2 = planeNorm(indices == 2, 1:2);

plot(color1(:,1), color1(:,2), '.b');
hold on
plot(color2(:,1), color2(:,2), '.k');
hold off

%% Calculate the time required to run
timeEnd = cputime - timeStart;
fprintf('Time to run: %.0f seconds\n', timeEnd) 