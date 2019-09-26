% Nicolas Tedori q4p2
% plot the likelihoods and posterior probabilities with decision boundary
% 9/29/2019

%% decision rule
syms x
u = 1;
s = sqrt(2);
x1 = -(u + s*((u^2) + (2*log(s)*(s^2 - 1)))^(1/2))/(s^2 - 1);
x2 = -(u - s*((u^2) + (2*log(s)*(s^2 - 1)))^(1/2))/(s^2 - 1);

syms w
% likelihoods
px1 = (1/sqrt(2*pi))*exp(-((w^2)/2));               % function for p(x|L=1)
px2 = (1/(2*sqrt(2*pi)))*exp(-(((w - 1)^2)/(2^2))); % function for p(x|L=2)
% posteriors
p1x = px1 / (px1 + px2);    % function for p(L=1|x)
p2x = px2 / (px1 + px2);    % function for p(L=2|x)

pRange = [-6 6]; % plot range

%% figure one for likelihoods (class-conditional pdfs)
figure(1)
hold on
fplot(px1, pRange, '--b')   % plot the function px1
fplot(px2, pRange, '--r')   % plot the function px2 
plot([x1 x1], [0 1], ':k')  % plot left decision boundary
plot([x2 x2], [0 1], ':k')  % plot right decision boundary
ylim([0 0.4])               % y-axis range
title({'Decision Boundary for Class-Conditional PDFs'})
xlabel('Distance from mean')
ylabel('P(x|L=l)')
legend('P(x|L=1)','P(x|L=2)', 'Decision Boundary')
hold off
print -depsc plot1.eps      % save plot as an eps file

%% figure 2 for posterior probabilities
figure(2)
hold on
fplot(p1x, pRange, '-g')    % plot the function p1x
fplot(p2x, pRange, '-m')    % plot the function p2x
plot([x1 x1], [0 1], ':k')  % plot left decision boundary
plot([x2 x2], [0 1], ':k')  % plot right decision boundary
ylim([0 1])                 % y-axis range
title('Decision Boundary for Posterior Probabilities')
xlabel('Distance from mean')
ylabel('P(L=l|x)')
legend('P(L=1|x)','P(L=2|x)', 'Decision Boundary')
print -depsc plot2.eps      % save plot as an eps file