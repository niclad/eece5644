function [x1, x2] = get_cuts(mdl)
%GET_CUTS Get the cuts of a tree model

x1 = [];
x2 = [];
% get tree boundaries
x = mdl.CutPoint;
y = mdl.CutPredictor;
for i = 1:length(x)
    if isnan(x(i))
        continue
    elseif isequal(y{i}, 'x1')
        x1 = [x1;x(i)];
    else
        x2 = [x2;x(i)];
    end
end
end

