function [result] = print_tree(node,spacing)
%PRINT_TREE Summary of this function goes here
%   Detailed explanation goes here

if class(node) == "Leaf"
    fprintf("%s Predict %.0f\n", spacing, node.predictions{1})
    return
end

fprintf("%s x%.0f < %.2f\n", spacing, node.question.column, node.question.value)
fprintf("%s --> True\n", spacing)
print_tree(node.trueBranch, append(spacing, "    "));

fprintf("%s --> False\n", spacing)
print_tree(node.falseBranch, append(spacing, "    "));

result = "--END--";

end

