% Nicolas Tedori
% EECE 5644
% October 21, 2019
% Midterm, Q1: Question 1

% clear workspace, console, and plots
% clc
% clear all
% close all

% generate the gaussian data
GenerateGaussian;

% get the actual number of samples generated
L1Samples = numClassSamples(1);
L2Samples = numClassSamples(2);
L3Samples = numClassSamples(3);

fprintf('The number of samples generated for each class:\n')
fprintf('Class L=1: %.0f\n', L1Samples)
fprintf('Class L=2: %.0f\n', L2Samples)
fprintf('Class L=3: %.0f\n', L3Samples)
figure(1)
% plot actual data
classSyms = {'ob', 'xr', 'dg'};
for i = 1:numClasses
    classSamples = [0, cumsum(numClassSamples)];
    rowRange = (classSamples(i) + 1):classSamples(i + 1);
    subplot(2, 1, 1);
    scatter(data(rowRange, 1), data(rowRange, 2), classSyms{i});
    hold on
end
xlabel('sample x')
ylabel('sample y')
title('True data classes')
legend('L=1', 'L=2', 'L=3');
hold off

% try LDA - BAD
classSyms = {'ob', 'xr', 'dg'};
misSyms   = {'om', 'xm', 'dm'};
[ldaIdx, ldaData] = my_lda(data, classIdx, numClassSamples);
[ldaIdxSort, idxOrder] = sort(ldaIdx);
l1Class = find(ldaIdx == 1);
l2Class = find(ldaIdx == 2);
l3Class = find(ldaIdx == 3);
ldaClasses = [length(l1Class), length(l2Class), length(l3Class)];
ldaDataSorted = ldaData(idxOrder, :);
for i = 1:numClasses
    classSamples = [0, cumsum(ldaClasses)];
    rowRange = (classSamples(i) + 1):classSamples(i + 1);
    subplot(2, 1, 2)
    scatter(ldaDataSorted(rowRange, 1), ldaDataSorted(rowRange, 2), classSyms{i})
    hold on
end
legend('L=1', 'L=2', 'L=3');
xlabel('sample x')
ylabel('sample y')
title('My classifier classification')
saveas(gcf, strcat('images/classification_comparison'), 'epsc')
hold off

% confusion matrix
confMat = confusionmat(classIdx, ldaIdx);
figure(2)
confusionchart(confMat);
title('Confusion Matrix for Misclassified Samples')
saveas(gcf, strcat('images/confusion-mat'), 'epsc')

% number of misclassifications from confmat
numMisclass = samples;
for i = 1:numClasses
    numMisclass = numMisclass - confMat(i, i);
end

fprintf('Number of missclassifications: %1.0f\n', numMisclass);
pError = numMisclass / samples * 100;
fprintf('Error estimate = %1.2f%%\n', pError);


% try something else i hadnt considered ??? maybe lda with kmeans??
