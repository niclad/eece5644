function [ind01MAP,ind10MAP,ind00MAP,ind11MAP,pEminERM, discrM] = classifyMAP(data, classIndex, mu, sigma, nSamples, prior)
% Expected Risk Minimization Classifier
dataTemp = data';
discrM = log(mvnpdf(dataTemp,mu(:,:,2)',sigma(:,:,2)))-log(mvnpdf(dataTemp,mu(:,:,1)',sigma(:,:,1)));
% MAP classifier (is a special case of ERM corresponding to 0-1 loss)
lambdaMAP = [0 1;1 0]; % 0-1 loss values yield MAP decision rule
gammaMAP = (lambdaMAP(2,1)-lambdaMAP(1,1))/(lambdaMAP(1,2)-lambdaMAP(2,2)) * prior(1)/prior(2); % threshold for MAP
decisionMAP = (discrM >= log(gammaMAP));
ind00MAP = find(decisionMAP==0 & classIndex'==1); 
p00MAP = length(ind00MAP)/sum(classIndex==1); % probability of true negative
ind10MAP = find(decisionMAP==1 & classIndex'==1); 
p10MAP = length(ind10MAP)/sum(classIndex==1); % probability of false positive
ind01MAP = find(decisionMAP==0 & classIndex'==2); 
p01MAP = length(ind01MAP)/sum(classIndex==2); % probability of false negative
ind11MAP = find(decisionMAP==1 & classIndex'==2); 
p11MAP = length(ind11MAP)/sum(classIndex==2); % probability of true positive
pEminERM = [p10MAP,p01MAP]*[sum(classIndex==1),sum(classIndex==2)]'/nSamples; % probability of error for MAP classifier, empirically estimated
end