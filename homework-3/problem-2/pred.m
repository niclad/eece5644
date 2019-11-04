function [ w, b ] = pred(w, b, X, Y, learn_rate, iter)
%PRED Summary of this function goes here
%   Detailed explanation goes here

costs = [];

for i = 1:iter
    [dw, db, cost] = optimizer(w, b, X, Y);
    
    w = w - (learn_rate * dw');
    b = b - (learn_rate * db);
    
    if mod(1, 100) == 0
        costs = [costs, cost];
    end
end

end

