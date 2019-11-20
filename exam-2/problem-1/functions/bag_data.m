function [ dataMTrain ] = bag_data(data)
%BAG_DATA randomly sample w replacement the data to obtain a training population
%   Detailed explanation goes here

% generate a data set from dataTrain
dataMIdx = randi([1,length(data)],length(data),1);    % get random indices
dataMTrain = data(dataMIdx,:);
end

