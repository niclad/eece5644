function [result] = classify(row,node)
%CLASSIFY Summary of this function goes here
%   Detailed explanation goes here

if class(node) == "Leaf"
    result = node.predictions;
    return
end

if node.question.match(row)
    result = classify(row, node.trueBranch);
    return
else
    result = classify(row, node.falseBranch);
    return
end    
end

