function [ node, numNode ] = build_tree(rows, numNode)
%BUILD_TREE Summary of this function goes here
%   Detailed explanation goes here

[gain, question] = find_best_split(rows);
gini = gini_impurity(rows);
if gini <= 0.01 || gain == 0 || numNode == 0
    node = Leaf(rows);
    return
end

[trueRows,falseRows] = partition(rows, question);

[trueBranch, numNode] = build_tree(trueRows, numNode - 1);
falseBranch = build_tree(falseRows, numNode);

node = DecisionNode(question, trueBranch, falseBranch);
return
end

