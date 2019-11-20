function [bestGain, bestQuestion] = find_best_split(rows)
%FIND_BEST_SPLIT Summary of this function goes here
%   Detailed explanation goes here

bestGain = 0;       % keep track of best information gain
bestQuestion = 0;   % keep train of attr / value that produced it
currUncertainty = gini_impurity(rows);
nAttrs = size(rows,2) - 1;

for col = 1:nAttrs
    values = unique(rows(:,col));
    
    for val = 1:length(values)
        question = Question(col, values(val));
        
        % try splitting data set
        [trueRows, falseRows] = partition(rows, question);
        
        % skip if theres no divide
        if isempty(trueRows) || isempty(falseRows)
            continue
        end
        
        % calculate information gain
        gain = info_gain(trueRows, falseRows, currUncertainty);
        
        if gain >= bestGain
            bestGain = gain;
            bestQuestion = question;
        end
    end
end
end

