% Nicolas Tedori
% EECE 5644
% November 4, 2019
% Homework 3 - Problem 1

% close all
% clear all
cpuStartTime = cputime; % get the time the cpu has been running for
%% Define variables for GMM
p1 = rand;          % randomly generate a weight for true cluster 1
m1 = rand(2,1);     % randomly generate a mean
c1 = rand(2, 2);    % randomly generate a 2x2 matrix
c1 = (c1' * c1);    % calculate a covariance matrix that is PSD

p2 = 1 - p1;        % see above comments
m2 = rand(2,1) * 2;
c2 = rand(2, 2);
c2 = (c2' * c2);

%% Generate GMM
mu    = [m1'; m2'];
sigma = cat(3, c1, c2);
comp  = [p1, p2];
gm    = gmdistribution(mu, sigma, comp);
gmPDF = @(x, y) reshape(pdf(gm, [x(:), y(:)]), size(x));
% visualize as a surf plot
figure(1)
fsurf(@(x, y) reshape(pdf(gm, [x(:), y(:)]), size(x)), [-1 3])
title('Distribution of GMM observations')
xlabel('x1')
ylabel('x2')
zlabel('Density of observations')
saveas(gcf,'surf-plot','epsc')

%% Generate samples 
%(mostly deprecated - observations are mostly generated on sample-by-sample
% basis in the loops below - left in for my own thought-processes' sake)

samples = [10, 100, 1000, 10000]; % test samples
%samples = [10, 100, 1000, 10000];  % number of observations to test

% trying one set of samples first
% data = random(gm, samples);
% 
% % set up folds for cross-validation
% k      = 10;            % number of folds
% idxNum = samples / k;   % number for an index in [1, 10]
% folds  = [];
% for i = 1:k
%     folds = [folds; repmat(i, idxNum, 1)];    % add appropriate number of indices
% end


figure(2)
scatter(data(:, 1), data(:, 2), '.r', 'LineWidth', 0.25) 
title('Scatter plot of observations')
xlabel('x1')
ylabel('x2')
saveas(gcf,'scatter','epsc')
%% EM
% initialize needed matrices for information needed later
numComp  = 6;    % number of GMM components to test
llVals   = zeros(length(samples), numComp);
avgComps = cell(length(samples), numComp);

% loop through the samples, running EM
for s = 1:length(samples)
    fprintf('> Running EM for %.0f samples.\n', samples(s))
    
    % generate data
    data = random(gm, samples(s)); % generate random data from the gmdistribution defined above

    % set up folds for cross-validation
    k      = 10;               % number of folds
    idxNum = samples(s) / k;   % number for an index in [1, 10]
    folds  = [];               % could be explicitly sized
    for i = 1:k
        folds = [folds; repmat(i, idxNum, 1)];    % add appropriate number of indices
    end
    
    % for the number of compoenents in 1:6, run EM on training data
    for nc = 1:numComp
        llValsTemp = zeros(k, 1); % matrix for log-likelihood values
        comps   = cell(k, 3);     % call array to store compenent data
        
        % for each fold run EM
        for i = 1:k
            % generate k folds
            testData = data(folds == k + 1 - i, :);  % test set will start at indices 10
            
            % move all data to train on into a single matrix
            kIdx = setdiff(1:10, (k + 1 - i));
            trainData = [];
            for j = 1:length(kIdx)
                trainData = [trainData; data(folds == kIdx(j), :)];
            end
            
            % initialization step with k means (could do differently) C is means
            [idx, C]  = kmeans(trainData, nc); % idx = cluster indices, C = centroids
            clusterMu = zeros(1, 2, nc);
            for clust = 1:nc
                clusterMu(:, :, clust) = C(clust, :);
            end
            
            % initialize cell arrays with lengths equal to number of clusters
            % (components = 2*numClusters)
            % Note: cell arrays are now 3D matrices - supposedly a little
            % faster and easier to visualize (plus no confusion over {} or
            % ().
            clusterData = cell(1, nc);      % left a cell array
            clusterCov  = zeros(2, 2, nc);
            clusterWgt  = zeros(1, 1, nc); 
            
            % get the data for each cluster and store in cell arrays
            for clust = 1:nc
                clusterData{clust} = data(idx == clust, :);
                clusterCov(:, :, clust)  = cov(clusterData{clust}) + (1e-6 * eye(2));
                clusterWgt(:, :, clust)  = length(clusterData{clust}) / length(trainData);
            end
           
            % run EM for at most 25 iterations 
            for itr = 1:25
                % initialize - needed mostly for the inital curLL
                if itr == 1
                    [ ll, post ] = E_Step(trainData, clusterMu, clusterCov, clusterWgt, nc);
                    [ muM, varM, wgtM ] = M_Step(trainData, post, nc);
                    curLL = ll;
                    llV   = ll;
                else
                    % expectation step - use on mu, covar, and weights from
                    % init step
                    [ ll, post ] = E_Step(trainData, muM, varM, wgtM, nc);
                    
                    % maximization step - use on data generated by previous
                    % e-step
                    [ muM, varM, wgtM ] = M_Step(trainData, post, nc);
                    
                    % determine if convergence has been reached
                    % Note: LL = log-likelihood
                    llDelta = abs(curLL - ll);  % get the difference in LLs
                    if llDelta < 1e-3           % convergence reached
                        break
                    else
                        curLL = ll;             % update the current LL
                    end
                end
            end
            
            % store components in a table. 
            % Note: This is stupid because if you average the components,
            % the average component fits usually turn out to be ovals.
            % Note 2.0: I dont use this anymore. See above note.
            comps{i, 1} = muM;
            comps{i, 2} = varM;
            comps{i, 3} = wgtM;
            
            % get log-likelihood values of test data
            llValsTemp(i) = LL_calc(testData, muM, varM, wgtM, nc);
        end
        llVals(s, nc)   = sum(llValsTemp) / k;
        %avgComps{s, nc} = mcomponents(comps, k, nc);
    end
end

% plot the data.
% figure(1)
% scatter(data(:, 1), data(:, 2), '.r')
% hold on
% correctGM = gmdistribution([muM(:,:,1); muM(:,:,2); muM(:,:,3); muM(:,:,4); muM(:,:,5); muM(:,:,6)], ...
%     cat(3, varM(:,:,1), varM(:,:,2), varM(:,:,3), varM(:,:,4), varM(:,:,5), varM(:,:,6)), ...
%     [wgtM(1), wgtM(2), wgtM(3), wgtM(4), wgtM(5), wgtM(6)]);
% gmPDF_new = @(x, y) reshape(pdf(correctGM, [x(:), y(:)]), size(x));
% fcontour(gmPDF_new, 'LineWidth', 1, 'LineStyle', '-')
% axis([-1.5 2.5 -1.5 2.5])
% %fcontour(gmPDF)
% hold off

figure(3)
for i = 1:length(samples)
    subplot(2, 2, i)
    rg = 1:6;
    [~, I] = max(llVals(i, :));
    plot(rg, -2*llVals(i, :), '-xk')
    set(gca, 'XTick', 0:7);
    t0 = sprintf('Cluster fits for %0.f observations', samples(i));
    t1 = sprintf('Best number of clusters: %0.f', rg(I));
    titleStr = {t0;t1};
    title(titleStr)
    ylabel('-2*log-likelihood')
    xlabel('Number of clusters')
end
saveas(gcf,'ll-curves','epsc')

% get the time the program has run for
cpuEnd  = cputime - cpuStartTime;   % in seconds
cpuMins = cpuEnd / 60;              % in minutes
cpuHrs  = cpuMins / 60;             % in hours
fprintf('SCRIPT RUN TIME\n')
fprintf('Seconds: %.2f\n',  cpuEnd)
fprintf('Minutes: %.2f\n', cpuMins)
fprintf('Hours:   %.2f\n',  cpuHrs)