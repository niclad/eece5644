% Nicolas Tedori
% EECE 5644
% October 9, 2019
% Homework 2 - Question 3
% lda.m

% clear console and workspace for a fresh start
%clear
clc

% generate data from the function for all the problems
%run_functions;     % will return p1 - p6 as variables for the iids

% testing with p1
p1Data = p1{:, 1:end-1};    % get numeric data from p1

%% step 1: find the amount of data of both classes
samples = height(p1);   % should be the number of samples input into the function
class = 'class 1';      % class to be determined

% this avoids having to grow matrices "dynamically"
% (supposed no-no in matlab)
% this feels super redundant :/
numClass = 0;
for i = 1:samples
    if class == p1{i, 3}
        numClass = numClass + 1;
    end
end

numOtherClass = samples - numClass;

%% step 2: sort data, class-wise, into their own matrices for LDA
p1c1 = zeros(numClass, 2);      % matrix for problem 1 class 1 data
p1c2 = zeros(numOtherClass, 2); % matrix for problem 1 class 2 data

% fill predetermined matrices
c1Idx = 1;
c2Idx = 1;
for i = 1:samples
    if class == p1{i, 3}
        p1c1(c1Idx, 1) = p1{i, 1};
        p1c1(c1Idx, 2) = p1{i, 2};
        c1Idx = c1Idx + 1;
    else
        p1c2(c2Idx, 1) = p1{i, 1};
        p1c2(c2Idx, 2) = p1{i, 2};
        c2Idx = c2Idx + 1;
    end
end

%% step 3: get class info
% get the calulated mean matrices for the classes
p1c1Mu = transpose(mean(p1c1));
p1c2Mu = transpose(mean(p1c2));

% get the calculated covariance matrices for the classes
p1c1Cov = cov(p1c1);
p1c2Cov = cov(p1c2);

% scatter matrices
sw = p1c1Cov + p1c2Cov;     % within-class scatter matrix
sb = (p1c1Mu - p1c2Mu) * transpose(p1c1Mu - p1c2Mu); % between-class scatter matrix

%% step 4: get the LDA projection
[v, d] = eig(sw \ sb); % projection vector
w1 = v(:, 1);
w2 = v(:, 2);

% pick the best w based on highest eigen value
if d(1,1) > d(2,2)
    w0 = w1;
else
    w0 = w2;
end

%% vishualishe
% plot class data
figure(1)
% class 1
scatter(p1c1(:, 1), p1c1(:, 2), 'ob')
hold on
plot(p1c1Mu(1), p1c1Mu(2), 'or', 'MarkerFaceColor', 'r')
% class 2
scatter(p1c2(:, 1), p1c2(:, 2), 'xr')
plot(p1c2Mu(1), p1c2Mu(2), 'sb', 'MarkerFaceColor', 'b')

% plot projection vector
t = -3:7;
lineX1 = t .* w1(1);
lineY1 = t .* w1(2);
plot(lineX1, lineY1, '--m')
lineX2 = t .* w2(1);
lineY2 = t .* w2(2);
plot(lineX2, lineY2, '--k')
legend('class 1', 'mu1', 'class 2', 'mu2', 'w1', 'w2')
xlabel('x1')
ylabel('x2')
title('Data samples with mean and projection vectors')
hold off

% pdfs 
c1 = p1c1 * w0;
c2 = p1c2 * w0;
% minY = min([min(c1), min(c2)]);
% maxY = max([max(c1), max(c2)]);
% c_w0 = [minY maxY];
c1Mean = mean(c1);
c2Mean = mean(c2);
c1Cov = cov(c1);
c2Cov = cov(c2);
c1pdf = mvnpdf(c1, c1Mean, c1Cov);
c2pdf = mvnpdf(c2, c2Mean, c2Cov);

% plot the pdfs
figure(2)
plot(c1, c1pdf, '.b')
hold on
plot(c2, c2pdf, '.r')
caption = sprintf('LDA PDFs for both classes. Eigenvalue = %.3f', max(d(1,1), d(2,2)));
title(caption)
xlabel('x')
ylabel('P(x|class = i)')
legend('class 1','class 2')
hold off

%% Classify the data based on mean distances from the LDA projection
% determine the distance from a mean for a point
numPointsC1 = length(c1);
ldaData = zeros(height(p1), 2);
ldaClass = table;

% classify points for class 1
for i = 1:numPointsC1
    % Determine distance
    c1Dist = abs(c1Mean - c1(i));
    c2Dist = abs(c2Mean - c1(i));
    
    % add point to data table
    ldaData(i, 1) = p1c1(i, 1);
    ldaData(i, 2) = p1c1(i, 2);
    
    % determine class for that point
    if c2Dist < c1Dist
        group = table({'class 2'});
    else
        group = table({'class 1'});
    end
    
    ldaClass = [ldaClass; group];
end

numPointsC2 = length(c2);
% classify points for class 2
for i = (numPointsC1 + 1):height(p1)
    actIdx = i - numPointsC1;
    % Determine distance
    c1Dist = abs(c1Mean - c2(actIdx));
    c2Dist = abs(c2Mean - c2(actIdx));
    
    % add point to data table
    ldaData(i, 1) = p1c2(actIdx, 1);
    ldaData(i, 2) = p1c2(actIdx, 2);
    
    % determine class for that point
    if c1Dist < c2Dist
        group = table({'class 1'});
    else
        group = table({'class 2'});
    end
    
    ldaClass = [ldaClass; group];
end

ldaData = array2table(ldaData);
ldaData = [ldaData ldaClass];
ldaData.Properties.VariableNames = {'x1', 'x2', 'class'};
ldaData.class = categorical(ldaData.class);

%% calculate error for LDA classifier
errorsFound = 0;
p1Sorted  = sortrows(p1);
ldaSorted = sortrows(ldaData);
for i = 1:height(p1)
    if p1Sorted{i, 3} ~= ldaSorted{i, 3}
        errorsFound = errorsFound + 1;
    end
end

classifierError = (errorsFound / height(p1)) * 100;
fprintf('Classifier error: %6.3f%%\n', classifierError)

%% plot LDA classified data
hold on
figure(3)
gscatter(ldaData{:,1}, ldaData{:,2}, ldaData.class, 'br', 'ox')
caption = sprintf('LDA classifier. Error = %6.2f%%', classifierError);
title(caption)
xlabel('x1')
ylabel('x2')
legend('class 1', 'class 2')

