function plotDecision(data,ind01,ind10,ind00,ind11)

plot(data(ind01,1),data(ind01,2),'+m'); hold on; % false negatives
plot(data(ind10,1),data(ind10,2),'om'); hold on; % false positives
plot(data(ind00,1),data(ind00,2),'+g'); hold on;
plot(data(ind11,1),data(ind11,2),'og'); hold on;
xlabel('x1');
ylabel('x2');
box on;
legend({'Misclassified as +','Misclassified as -', 'Classified as +', ...
    'Classified as -'});

end