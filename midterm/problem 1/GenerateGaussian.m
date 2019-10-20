% Nicolas Tedori
% EECE 5644
% october 21, 2019
% Midterm, Q1: Generate Guassian data
% code from Homework 2 solutions - seems to be more efficient than my
%     previous method

priors = [0.15; 0.35; 0.5]; % class priors, according to index
% class mean matrices
mu{1} = [-1; 0];
mu{2} = [ 1; 0];
mu{3} = [ 0; 1];
% class covariance matrices
cov{1} = [1, -0.4; -0.4, 0.5];
cov{2} = [0.5,  0;    0, 0.2];
cov{3} = [0.1,  0;    0, 0.1];

samples = 10000; % the number of samples

classScalar = rand(samples, 1); % generate an array of size samples x 1
priorThresholds = [0; cumsum(priors)]; % create the ranges for the data gen
numClasses = numel(mu); % get the number of classes
data = cell(numClasses, 1); % create a cell array for the data
classIdx = data;    % create a cell array for the classes
numClassSamples = zeros(1, numClasses);

for class = 1:numClasses
    % get the number of samples that fall within a classes threshold
    % side note: will nnz ignore a number if it's 0?
    classSamples = nnz(classScalar >= priorThresholds(class) & ...
        classScalar < priorThresholds(class + 1));
    
    % generate classSamples amount of data from Guassian dist.
    data{class} = mvnrnd(mu{class}, cov{class}, classSamples);
    
    % assign the class to that data
    classIdx{class} = ones(classSamples, 1) * class;
    
    % save the number of samples generated for a class
    numClassSamples(class) = classSamples;
end

data = cell2mat(data);
classIdx = cell2mat(classIdx);
