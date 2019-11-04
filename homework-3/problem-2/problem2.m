% Nicolas Tedori
% EECE 5644
% November 4, 2019
% Homework 3 - Question 2

clear all
close all

cpuStart = cputime;     % time the cpu run
SAMPLES  = 999;         % number of samples

%% Data parameters

% class - (m = -)
qm    = 0.3;            % class prior
qmMu  = [0.2; 0.3];     % class mean 
qmSig = [0.2 -1; ...    % create a matrix
    0.1 0.02];
qmSig = qmSig' * qmSig; % class covariance matrix

% class + (p = +)
qp    = 0.7;            % class prior
qpMu = [1.4; 0.60];      % class mean vector
qpSig = [0.2 0.65; ...
    0.65 0.6];
qpSig = qpSig' * qpSig; % class covariance matrix

%% Generate data
mu  = cat(3, qmMu, qpMu);       % means
sig = cat(3, qmSig, qpSig);     % covariances
wgt = cat(3, qm, qp);           % weights

[data, classIndex, obsNum] = generate_data(mu, sig, wgt, SAMPLES);    % generate gaussian data
[w0, pE, tn_lda, fp_lda, fn_lda, tp_lda, roc, discr, t] = f_lda(data, classIndex, obsNum);
[ind01MAP,ind10MAP,ind00MAP,ind11MAP, pE_MAP, discrm] = classifyMAP(data', classIndex', cat(3, qmMu, qpMu), cat(3, qmSig, qpSig), SAMPLES, cat(3, qm, qp));

w = zeros(1, 2);
b = 0;

fun = @(x) optimizer(x, data, classIndex, classIndex);
w = fminsearch(fun, [w0;0]);
[ind00, ind10, ind01, ind11, Pe, discrr] = log_reg(data, w, classIndex);
% anonymous function to plot w0
b = 0;
discrFun     = @(x1, x2) w0' * [x1; x2] + b;
discrFunPlot = @(x) (w0(2) / w0(1)) * x + b;

% get axis values
xAxisMin = floor(min(data(:,1)));
xAxisMax = ceil(max(data(:,1)));
yAxisMin = floor(min(data(:,2)));
yAxisMax = ceil(max(data(:,2)));

% plot data and projection vector
figure(1)
scatter(data(classIndex == 1, 1), data(classIndex == 1, 2), 'or')
hold on
scatter(data(classIndex == 2, 1), data(classIndex == 2, 2), '+b')
%fplot(discrFunPlot, '--k', 'LineWidth', 2)
box on
axis([xAxisMin xAxisMax yAxisMin yAxisMax])
hold off
legend('L="-"', 'L="+"')
title('True class labels')
xlabel('x1')
ylabel('x2')
saveas(gcf,'real_labels','epsc')

figure(2)
subplot(3, 1, 1)
plotDecision(data, fn_lda, fp_lda, tn_lda, tp_lda);
title(sprintf('LDA Classifier, P(e) = %0.2f', pE));
subplot(3, 1, 2)
plotDecision(data, ind01MAP,ind10MAP,ind00MAP,ind11MAP);
title(sprintf('MAP Classifier, P(e) = %0.2f', pE_MAP));
subplot(3, 1, 3)
plotDecision(data, ind00, ind10, ind01, ind11);
title(sprintf('Logisitic Reg Classifier, P(e) = %0.2f', Pe));

figure(3)
[xl, yl] = roc_curve(data, classIndex, discr);
%[xm, ym] = roc_curve(data, classIndex, discrm);
[xr, yr] = roc_curve(data, classIndex, discrr);
plot(xl, yl, '-r', 'LineWidth', 3)
hold on
%plot(xm, ym, '--b', 'LineWidth', 2)
%plot(xr, yr, '-.r', 'LineWidth', 1)
hold off
legend('LDA', 'MAP');
title('ROC Curve for classifers tested')
xlabel('False positive')
ylabel('True positive')



