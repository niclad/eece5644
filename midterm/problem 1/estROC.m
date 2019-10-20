function [outputArg1,outputArg2] = estROC(dsLDA,class)
%ESTROX Summary of this function goes here

ng = [length(find(class == 1)), length(find(class == 2)), length(find(class == 3))];
sortedScore = [sort(dsLDA(1)), sort(dsLDA(2)), sort(dsLDA(3))];
tau = 
end

