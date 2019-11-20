function [ mytree ] = myd3(data)
%MYD3 My ID3 algorithm for gettin splits
%   Determine splitting criteria based on the splits for the range defined
%   below (testRange)

testRange = -1:0.02:1;



% empty tree
idx = {1:12};   % max of 12 nodes
p   = 0;        % index of parent node
labels = {};

% split on the root, creating sub-tree
[idx,p,labels] = split_node(data, idx, p, 1, labels);

mytree.idx    = idx;
mytree.p      = p;
mytree.labels = labels;
end

