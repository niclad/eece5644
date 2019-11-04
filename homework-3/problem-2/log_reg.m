function [ind00, ind10, ind01, ind11, Pe, discr] = log_reg(data,w, classIndex)
%LOG_REG Summary of this function goes here
%   Detailed explanation goes here

LR = @(x) 1 / (1 + exp(w(1:2)'*x' + w(3)));

discr = zeros(size(data, 1), 1);

for i = 1:size(discr)
    discr(i) = LR(data(i, :));
end
discr
ld = length(discr);

classResults = zeros(ld, 1);

for i = 1:discr
    if discr(i) > 0.5
        k = 1;
    else
        k = 2;
    end
    
    classResults(i) = k;
end
classResults;

ind00 = find(classResults == 2 & classIndex == 2); % tn
ind10 = find(classResults == 1 & classIndex == 2);    % false positive
ind01 = find(classResults == 2 & classIndex == 1);    % false negative
ind11 = find(classResults == 1 & classIndex == 1);    % true positive

Pe = 1- sum(classIndex==1)/sum(classResults == 1);

end

