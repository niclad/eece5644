% Nicolas Tedori q2p3 plot log likelihood ratio
% 9/29/2019

sym x;
llr = 2 * exp(((-2 * abs(x)) + abs(x - 1))/2);
range_val = 15;
plot_range = [-range_val range_val];
fplot(llr, plot_range)
title('Log-likelihood-ratio for question 2, problem 3')
xlabel('x')
ylabel('l(x)')
ylim([0 3.5])