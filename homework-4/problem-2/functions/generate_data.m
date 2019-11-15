function [ data, indices, nnClass ] = generate_data(mu, sig, wgt, r, c, samples)
%GENERATE_DATA Generates data for the two classes
%   Note: this is a special function that will generate data from the two
%   classes. Class -1 is a normal gaussian, but class two is distributed
%   around a chord

% initialize ouptus
indices = cell(2, 1);   % note: for 2 classes
data    = cell(2, 1);

classThresh = rand(samples, 1);
thresh      = [0, cumsum(wgt)];
nnClass     = zeros(2, 1);          % number of samples in a class

for class = 1:2
    % get number of samples in a class
    classSamples = nnz(classThresh >= thresh(class) & ...
        classThresh < thresh(class + 1));
    
    % generate data using a method determined by the class
    if class == 1
        data{class} = mvnrnd(mu, sig, classSamples);
    else
        data{class} = rndpt(r, c, classSamples);
    end
    
    % assign class to this set of data
    indices{class} = ones(classSamples, 1) * class;
    
    % save the number of samples
    nnClass(class) = classSamples;
end

% convert cell arrays to matrices
data    = cell2mat(data);
indices = cell2mat(indices);
end