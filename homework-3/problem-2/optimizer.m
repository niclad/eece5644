function [ w ] = optimizer(w, X, Y, classInd)
%OPTIMIZER Summary of this function goes here
%   Detailed explanation goes here

numX1 = sum(classInd == 1);
numX2 = 999 - numX1;
Y = [0, 1];

p = 0;
for i = 1:numX1
    Xw = [X(i, :), 1];
    p = w' * Xw';
end
p = Y(1)*p - log(1 + exp(p));
    
    
for i = numX2:999
    Xw = [X(i, :), 1];
    q = w' * Xw';
end
q = Y(2)*q - log(1 + exp(q));

lW = p + q;

w = -lW;

end

