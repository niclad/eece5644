% Nicolas Tedori
% EECE 5644 
% November 14, 2019
% Homework 4 - Problem 1

% add the functions path
addpath(genpath('./functions/'))

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
% plane data
[planeNorm, ~] = image_normalizer(planeImg);
planeNorm(:,2) = flip(planeNorm(:,2));

% bird data
[birdNorm, ~]  = image_normalizer(birdImg);
birdNorm(:,2)  = flip(birdNorm(:,2));

%% Run K-Means

maxIter = 75;   % define a maximum iterations incase convergence is never reached

colors  = {'.b','.k','.r','.g','.y','.m','.c','.w'}; % colors used for plotting
kmStart = cputime;
% run k-means for plane
figure(1)
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
saveas(gcf,'images/km_plane','epsc')   % save plot as an eps

% k-means for bird
figure(2)
for k = 2:5
    centroids = init_centroids(birdNorm, k);
    prevCentr = centroids;
    n = 1;
    while ~isequal(prevCentr, centroids) || (n < maxIter)
        indices   = closest_centroids(birdNorm, centroids, k);
        centroids = compute_centroids(birdNorm, indices, k);
        prevCentr = centroids;
        n         = n + 1;
    end
    
    % plot the image for the k
    subplot(2, 2, k-1);
    for i = 1:k
        % partition data into easily-accessible data mat
        plot_data = birdNorm(indices == i, 1:2);
        % plot the data mat
        plot(plot_data(:,1), plot_data(:,2), colors{i}, 'MarkerSize', 1);
        hold on
    end
    title(sprintf('K-means bird jpg for k=%.0f', k));
    xlabel('x-pixels')
    ylabel('y-pixels')
    
end
saveas(gcf,'images/km_bird','epsc')   % save plot as an eps

% get time to run k-means
kmTime = cputime - kmStart;
fprintf('Time to run k-means: %.1f seconds\n', kmTime)

%% Run GMM

gmmStart = cputime;

% gmm for plane
figure(3)
for k = 2:5
    
    % run "EM" on data
    % Note: this is not correct - only using Matlabs so that I can write
    % the rest of the code
    planeGM = fitgmdist(planeNorm, k);
        
    % get a cluster number for an observation.
    indices = map_classify(planeNorm, planeGM, k);
    
    % plot the image for the k
    subplot(2, 2, k-1);
    for i = 1:k
        % partition data into easily-accessible data mat
        plot_data = planeNorm(indices == i, 1:2);
        % plot the data mat
        plot(plot_data(:,1), plot_data(:,2), colors{i}, 'MarkerSize', 1);
        hold on
    end
    title(sprintf('GMM plane jpg for k=%.0f', k));
    xlabel('x-pixels')
    ylabel('y-pixels')
    
end
saveas(gcf,'images/gmm_plane','epsc')   % save plot as an eps

% gmm for bird
figure(4)
for k = 2:5
    
    % run "EM" on data
    % Note: this is not correct - only using Matlabs so that I can write
    % the rest of the code
    birdGM = fitgmdist(birdNorm, k);
        
    % get a cluster number for an observation.
    indices = map_classify(birdNorm, birdGM, k);
    
    % plot the image for the k
    subplot(2, 2, k-1);
    for i = 1:k
        % partition data into easily-accessible data mat
        plot_data = planeNorm(indices == i, 1:2);
        % plot the data mat
        plot(plot_data(:,1), plot_data(:,2), colors{i}, 'MarkerSize', 1);
        hold on
    end
    title(sprintf('GMM bird jpg for k=%.0f', k));
    xlabel('x-pixels')
    ylabel('y-pixels')
    
end
saveas(gcf,'images/gmm_bird','epsc')

% time to run gmm
gmmTime = cputime - gmmStart;
fprintf('Time to run GMM: %.1f seconds\n', gmmTime)

%% Calculate the time required to run
timeEnd = cputime - timeStart;
fprintf('Total runtime: %.1f seconds\n', timeEnd) 