% Nicolas Tedori q4p2
% 9/29/2019

% decision rule
syms x
u = 1;
s = sqrt(2);
x1 = -(u + s*((u^2) + (2*log(s)*(s^2 - 1)))^(1/2))/(s^2 - 1);
x2 = -(u - s*((u^2) + (2*log(s)*(s^2 - 1)))^(1/2))/(s^2 - 1);

syms w
% likelihoods
px1 = (1/sqrt(2*pi))*exp(-((w^2)/2));
px2 = (1/(2*sqrt(2*pi)))*exp(-(((w - 1)^2)/(2^2)));
% posteriors
p1x = px1 / (px1 + px2);
p2x = px2 / (px1 + px2);

pRange = [-6 6];
figure(1)
hold on
fplot(px1, pRange, '--b')
fplot(px2, pRange, '--r')
plot([x1 x1], [0 1], ':k')
plot([x2 x2], [0 1], ':k')
ylim([0 0.4])
title({'Decision Boundary for Likelihoods'})
xlabel('Distance from mean')
ylabel('P(x)')
legend('P(x|L=1)','P(x|L=2)', 'Decision Boundary')
hold off
print -depsc plot1.eps
figure(2)
hold on
fplot(p1x, pRange, '-g')
fplot(p2x, pRange, '-m')
plot([x1 x1], [0 1], ':k')
plot([x2 x2], [0 1], ':k')
ylim([0 1])
title('Posterior Probabilities for Two-Class Setting')
xlabel('Distance from mean')
ylabel('P(x)')
legend('P(L=1|x)','P(L=2|x)', 'Decision Boundary')
print -depsc plot2.eps