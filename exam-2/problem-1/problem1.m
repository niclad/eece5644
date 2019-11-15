% Nicolas Tedori
% EECE 5644 
% November 22, 2019
% Exam 2 - Problem 1

close all

% add the functions path
addpath(genpath('./functions/'))

% time program
timeStart = cputime;


%% display the runtime for the whole program
timeEnd = cputime - timeStart;
fprintf('Total runtime: %0.3f s\n', timeEnd)
