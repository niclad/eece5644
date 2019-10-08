% Nicolas Tedori
% EECE 5644
% October 9, 2019
% Homework 2 - Question 2
% INPUTS:
%   samples: number of samples requested
%   c1Mu, c2Mu: mean matrices for classes 1 and 2, respectively
%   c1Cov, c2Cov: covariance matrices for classes 1 and 2, respectively
%   pC1, pC2: prior probabilities for classes 1 and 2, respectively
%   plot: string containing plot name

function iid = MAP_Classify(samples, c1Mu, c2Mu, c1Cov, c2Cov, pC1, pC2,...
    plot)
%% generate gaussian data
fprintf('Generating Guassian data....\n')

gndTruth = zeros(samples, 2);  % generate a samples-by-2 matrix for samples
sampleLabel = table;  % table for class labels

% loop generating a new sample determined by priors
for i = 1:samples
    class = rand;   % randomly generate a number between 
    
    if class <= pC1
        group = table({'class 1'});      % assign class 1
        x = mvnrnd(c1Mu, c1Cov);% get a random value from the gaussian pdf
    else
        group = table({'class 2'});      % assign class 2
        x = mvnrnd(c2Mu, c1Cov);% get a random value from the gaussian pdf
    end
    
    % add generated value into the table of samples
    gndTruth(i, 1) = x(1, 1);
    gndTruth(i, 2) = x(1, 2);
    sampleLabel = [sampleLabel; group];
    
end

numData = gndTruth;     % get numerical data
gndTruth = array2table(gndTruth);   % make gndTruth a table
gndTruth = [gndTruth sampleLabel];  % concat the two tables
gndTruth.Properties.VariableNames = {'x1', 'x2', 'class'};  % set col names
gndTruth.class = categorical(gndTruth.class);
fprintf('Guassian data generated.\n')

%% plot and save the gnd truth data
fprintf('Plotting and saving ground truth data\n')
hold on
figure(1)
gscatter(numData(:,1), numData(:,2), gndTruth.class, 'br', 'ox')
title({'Samples=400, means=[0;0], [3;3]';'Identity Cov; equal priors'})
xlabel('x1')
ylabel('x2')
saveas(gcf, strcat('gndTruth_', plot), 'epsc')   % save plot as an eps
hold off

%% MAP classifier
fprintf('Classifying numeric data using MAP....\n')
mapData = numData;
mapLabel = table;
for i = 1:samples
    % determine the pdf of the data at the ith postion in table
    pdf1 = mvnpdf(transpose(mapData(i, :)), c1Mu, c1Cov) .* pC1;
    pdf2 = mvnpdf(transpose(mapData(i, :)), c2Mu, c2Cov) .* pC2;
    
    if max(pdf1, pdf2) == pdf1
        group = table({'class 1'});
    else
        group = table({'class 2'});
    end
    
    mapLabel = [mapLabel; group];
end

mapData = array2table(mapData);
mapData = [mapData mapLabel];
mapData.Properties.VariableNames = {'x1', 'x2', 'class'};
mapData.class = categorical(mapData.class);

fprintf('Classification complete.\n')

%% plot the MAP data
fprintf('Plotting and saving MAP classified data\n')
hold on
figure(2)
gscatter(numData(:,1), numData(:,2), mapData.class, 'br', 'ox')
title({'MAP classifier data'})
xlabel('x1')
ylabel('y1')
saveas(gcf, strcat('mapClassifier_', plot), 'epsc')   % save plot as an eps
hold off

%% determine the error
fprintf('Determining the error in MAP classifier....\n')

errorsFound = 0;
for i = 1:samples
    if gndTruth{i, 3} ~= mapData{i, 3}
        errorsFound = errorsFound + 1;
    end
end

% should always be true unless my code is more garbage than I thought
classifierError = (errorsFound / samples) * 100;
fprintf('Classifier error: %.3f%%\n', classifierError)

iid = gndTruth;
end