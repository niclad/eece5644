function [ data, classIndex, ncs ] = generate_data(mu, cov, wgt, samples)
%GENERATE_DATA Generate gaussian data.
%   Detailed explanation goes here

% determine the number of classes
classes = size(mu, 3);

% convert wgt to a 1x2
tempWgt = zeros(1, 2);
for i = 1:classes
    tempWgt(i) = wgt(:,:,i);
end
wgt = tempWgt;    

classScalar = rand(samples, 1);
priorThresh = [0, cumsum(wgt)];

data = cell(classes, 1);       % data cell-array
classIndex = data;             % index cell-array

ncs = zeros(1, classes);       % numer of class observations

for class = 1:classes
    % get the number of samples for a class
    classSamples = nnz(classScalar >= priorThresh(class) & ...
        classScalar < priorThresh(class + 1));
    
    % generate data 
    data{class} = mvnrnd(mu(:,:,class)', cov(:,:,class), classSamples);
    
    % assign the class to that data
    classIndex{class} = ones(classSamples, 1) * class;
    
    % save the number of samples generate for a class
    ncs(class) = classSamples;
end

data = cell2mat(data);              % convert data cell-array to a matrix
classIndex = cell2mat(classIndex);  % convert index cell-array to a matrix
end
