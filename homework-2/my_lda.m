% Nicolas Tedori
% EECE 5644
% October 9, 2019
% Homework 2 - Question 3
% lda.m

function my_lda(iid, plotName)

% generate data from the function for all the problems
%run_functions;

%% step 1: find the amount of data of both classes
samples = height(iid);   % should be the number of samples input into the function
class = 'class 1';      % class to be determined

% this avoids having to grow matrices "dynamically"
% (supposed no-no in matlab)
% this feels super redundant :/
numClass = 0;
for i = 1:samples
    if class == iid{i, 3}
        numClass = numClass + 1;
    end
end

numOtherClass = samples - numClass;

%% step 2: sort data, class-wise, into their own matrices for LDA
c1Data = zeros(numClass, 2);      % matrix for problem 1 class 1 data
c2Data = zeros(numOtherClass, 2); % matrix for problem 1 class 2 data

% fill predetermined matrices
c1Idx = 1;
c2Idx = 1;
for i = 1:samples
    if class == iid{i, 3}
        c1Data(c1Idx, 1) = iid{i, 1};
        c1Data(c1Idx, 2) = iid{i, 2};
        c1Idx = c1Idx + 1;
    else
        c2Data(c2Idx, 1) = iid{i, 1};
        c2Data(c2Idx, 2) = iid{i, 2};
        c2Idx = c2Idx + 1;
    end
end

%% step 3: get class info
% get the calulated mean matrices for the classes
c1Mu = transpose(mean(c1Data));
c2Mu = transpose(mean(c2Data));

% get the calculated covariance matrices for the classes
c1Cov = cov(c1Data);
c2Cov = cov(c2Data);

% scatter matrices
sw = c1Cov + c2Cov;     % within-class scatter matrix
sb = (c1Mu - c2Mu) * transpose(c1Mu - c2Mu); % between-class scatter matrix

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
scatter(c1Data(:, 1), c1Data(:, 2), 'ob')
hold on
plot(c1Mu(1), c1Mu(2), 'or', 'MarkerFaceColor', 'r')
% class 2
scatter(c2Data(:, 1), c2Data(:, 2), 'xr')
plot(c2Mu(1), c2Mu(2), 'sb', 'MarkerFaceColor', 'b')

% plot projection vector
minX = min([min(c1Data), min(c2Data)]);
maxX = max([max(c1Data), max(c2Data)]);
t = minX:maxX;
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
saveas(gcf, strcat('images/rawData_', plotName), 'epsc')
hold off

% pdfs 
c1 = c1Data * w0;
c2 = c2Data * w0;
% minY = min([min(c1), min(c2)]);
% maxY = max([max(c1), max(c2)]);
% c_w0 = [minY maxY];
c1Mean = mean(c1);
c2Mean = mean(c2);
c1CovLDA = cov(c1);
c2CovLDA = cov(c2);
c1pdf = mvnpdf(c1, c1Mean, c1CovLDA);
c2pdf = mvnpdf(c2, c2Mean, c2CovLDA);

% plot the pdfs
figure(2)
plot(c1, c1pdf, '.b')
hold on
plot(c2, c2pdf, '.r')
caption = sprintf('LDA PDFs for both classes. Eigenvalue = %.3f', max(d(1,1), d(2,2)));
captionW0 = sprintf('w0 = [%.2f, %.2f]', w0(1), w0(2));
title({caption; captionW0})
xlabel('x')
ylabel('P(x|class = i)')
legend('class 1','class 2')
saveas(gcf, strcat('images/ldaPDF_', plotName), 'epsc')
hold off

%% Classify the data based on mean distances from the LDA projection
% determine the distance from a mean for a point
numPointsC1 = length(c1);
ldaData = zeros(samples, 2);
ldaClass = table;

% classify points for class 1
for i = 1:numPointsC1
    % Determine distance
    c1Dist = abs(c1Mean - c1(i));
    c2Dist = abs(c2Mean - c1(i));
    
    % add point to data table
    ldaData(i, 1) = c1Data(i, 1);
    ldaData(i, 2) = c1Data(i, 2);
    
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
for i = (numPointsC1 + 1):samples
    actIdx = i - numPointsC1;
    % Determine distance
    c1Dist = abs(c1Mean - c2(actIdx));
    c2Dist = abs(c2Mean - c2(actIdx));
    
    % add point to data table
    ldaData(i, 1) = c2Data(actIdx, 1);
    ldaData(i, 2) = c2Data(actIdx, 2);
    
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
p1Sorted  = sortrows(iid);
ldaSorted = sortrows(ldaData);
for i = 1:samples
    if p1Sorted{i, 3} ~= ldaSorted{i, 3}
        errorsFound = errorsFound + 1;
    end
end

classifierError = (errorsFound / samples) * 100;
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
saveas(gcf, strcat('images/ldaClass_', plotName), 'epsc')
hold off

end