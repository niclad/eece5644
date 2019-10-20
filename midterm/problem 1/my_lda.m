function [ldaIdx, ldaData] = my_lda(data, class, classSamples)
totalSamples = cumsum(classSamples);
% calculate mean and cov
l1 = data(1:totalSamples(1), :);
l2 = data(totalSamples(1) + 1:totalSamples(2), :);
l3 = data(totalSamples(2) + 1:totalSamples(3), :);

l1Mu = mean(l1);
l2Mu = mean(l2);
l3Mu = mean(l3);
mu = (l1Mu + l2Mu + l3Mu) ./ 3;

l1Cov = cov(l1);
l2Cov = cov(l2);
l3Cov = cov(l3);

% w/in class scatter mat
sw = l1Cov + l2Cov + l3Cov;

% between class scatter mat
sb1 = classSamples(1) .* transpose(l1Mu - mu) * (l1Mu - mu);
sb2 = classSamples(2) .* transpose(l2Mu - mu) * (l2Mu - mu);
sb3 = classSamples(3) .* transpose(l3Mu - mu) * (l3Mu - mu);
sb = sb1 + sb2 + sb3;

[v, d] = eig(sw \ sb);

if d(1, 1) > d(2, 2)
    w0 = v(:, 1);
else
    w0 = v(:, 2);
end

l1Data = l1 * w0;
l2Data = l2 * w0;
l3Data = l3 * w0;

length(l1Data)
length(l2Data)
length(l3Data)

l1Mean = mean(l1Data);
l2Mean = mean(l2Data);
l3Mean = mean(l3Data);

ldaData = zeros(sum(classSamples), 2);
%ldaIdx  = zeros(sum(classSamples), 1);
ldaIdx = table;

%% classify data

for i = 1:length(l1Data)
    l1Dist = abs(l1Mean - l1Data(i));
    l2Dist = abs(l2Mean - l1Data(i));
    l3Dist = abs(l3Mean - l1Data(i));
    
    % classify points for class 1
    ldaData(i, 1) = l1(i, 1);
    ldaData(i, 2) = l1(i, 2);
    
    if l1Dist < l2Dist
        if l1Dist <= l3Dist
            ldaIdx = [ldaIdx;{1}];
        else
            ldaIdx = [ldaIdx;{3}];
        end
    elseif l2Dist < l3Dist
        ldaIdx = [ldaIdx;{2}];
    else
        ldaIdx = [ldaIdx;{3}];
    end
end

for i = 1:length(l2Data)
    l1Dist = abs(l1Mean - l2Data(i));
    l2Dist = abs(l2Mean - l2Data(i));
    l3Dist = abs(l3Mean - l2Data(i));
    
    % classify points for class 1
    ldaData(length(l1Data) + i, 1) = l2(i, 1);
    ldaData(length(l1Data) + i, 2) = l2(i, 2);
    
    % classify points for class 2
    if l1Dist < l2Dist
        if l1Dist < l3Dist
            ldaIdx = [ldaIdx;{1}];
        else
            ldaIdx = [ldaIdx;{3}];
        end
    elseif l2Dist < l3Dist
        ldaIdx = [ldaIdx;{2}];
    else
        ldaIdx = [ldaIdx;{3}];
    end
       
end

for i = 1:length(l3Data)
    l1Dist = abs(l1Mean - l3Data(i));
    l2Dist = abs(l2Mean - l3Data(i));
    l3Dist = abs(l3Mean - l3Data(i));
    
    % classify points for class 1
    ldaData(length(l2Data) + i, 1) = l3(i, 1);
    ldaData(length(l2Data) + i, 2) = l3(i, 2);
        
    % classify points for class 3
    if l1Dist < l2Dist
        if l1Dist < l3Dist
            ldaIdx = [ldaIdx;{1}];
        else
            ldaIdx = [ldaIdx;{3}];
        end
    elseif l2Dist < l3Dist
        ldaIdx = [ldaIdx;{2}];
    else
        ldaIdx = [ldaIdx;{3}];
    end
    
end
ldaIdx = table2array(ldaIdx);
% misclassified data points
l1Miss = find(ldaIdx == 1);
l2Miss = find(ldaIdx == 2);
l3Miss = find(ldaIdx == 3);

% l1Idx = l1Miss == class(1:totalSamples(1));
% l2Idx = l2Miss == class(totalSamples(1) + 1:totalSamples(2));
% l3Idx = l3Miss == class(totalSamples(2) + 1:totalSamples(3));

% t = -2.5:2.5;
% line1 = t .* w0(1);
% line2 = t .* w0(2);
% plot(line1, line2, 'k--', 'LineWidth', 2)
% 
% x1 = l1 * w0;
% x2 = l2 * w0;
% x3 = l3 * w0;
% 
% x1Mu = mean(x1);
% x2Mu = mean(x2);
% x3Mu = mean(x3);
% 
% x1Cov = cov(x1);
% x2Cov = cov(x2);
% x3Cov = cov(x3);
% 
% x1pdf = mvnpdf(x1, x1Mu, x1Cov);
% x2pdf = mvnpdf(x2, x2Mu, x2Cov);
% x3pdf = mvnpdf(x3, x3Mu, x3Cov);
% 
% figure(2)
% plot(x1, x1pdf, '.b')
% hold on
% plot(x2, x2pdf, '.r')
% plot(x3, x3pdf, '.g')

end

