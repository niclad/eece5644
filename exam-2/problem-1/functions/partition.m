function [tr, fr] = partition(rows, question)
%PARTITION partitions dataset
%   Detailed explanation goes here

fr = [];
tr = [];

for i = 1:size(rows,1)
    if question.match(rows(i,:))
        tr = [tr;rows(i,:)];
    else
        fr = [fr;rows(i,:)];
    end
end
end

