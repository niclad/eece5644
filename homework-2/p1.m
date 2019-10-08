% Nicolas Tedori
% EECE 5644
% Homework 2 - Question 2, Problem 1

function iid = p1(samples)
% Generates a specified number of IID samples
%   Taking in a specified number of samples, the function returns a number
%   of IID samples paired with class labels

%% samples = 400; means = [0;0], [3;3]; covMat = I; pC1 == pC2

% class means
c1Mu = [0; 0];
c2Mu = [3; 3];

% covariance matrices
c1Cov = eye(2);
c2Cov = c1Cov;

% class priors (equal)
pC1 = 0.5;
pC2 = pC1;

%% generate gaussian data
fprintf('Generating Guassian data....\n')

gndTruth = zeros(samples, 2);   % generate a samples-by-2 matrix for samples
sampleLabel = table;  % table for class labels

% loop generating a new sample determined by priors
for i = 1:samples
    class = randi([1 100]);     % pick a random number from the  
                                % uniform distribution between 1 and 100
    if class < 51
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

%% plot the gnd truth data
fprintf('Plotting ground truth data\n')
hold on
figure(1)
gscatter(numData(:,1), numData(:,2), gndTruth.class, 'br', 'ox')
title({'Samples=400, means=[0;0], [3;3]';'Identity Cov; equal priors'})
xlabel('x1')
ylabel('x2')
print -depsc gndTruth_q2p1.eps   % save plot as an eps
hold off

%% MAP classifier
fprintf('Classifying numeric data using MAP....\n')
mapData = numData;
mapLabel = table;
for i = 1:samples
    % determine the pdf of the data at the ith postion in table
    pdf1 = mvnpdf(mapData(i, :), transpose(c1Mu), c1Cov) .* pC1;
    pdf2 = mvnpdf(mapData(i, :), transpose(c2Mu), c2Cov) .* pC2;
    
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
fprintf('Plotting MAP classified data\n')
hold on
figure(2)
gscatter(numData(:,1), numData(:,2), mapData.class, 'br', 'ox')
title({'MAP classifier data'})
xlabel('x1')
ylabel('y1')
print -depsc mapClassifier_q2p1.eps   % save plot as an eps
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
fprintf('Classifier error: %.0d%%\n', classifierError)

iid = gndTruth;
end