% Nicolas Tedori q4p2
% 9/29/2019

% decision rule
syms x u s
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
hold on
fplot(px1, pRange, '--b')
fplot(px2, pRange, '--r')
fplot(p1x, pRange, '-g')
fplot(p2x, pRange, '-m')
legend('P(x|L=1)','P(x|L=2)','P(L=1|x)','P(L=2|x)')