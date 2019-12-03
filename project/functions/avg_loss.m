function [ avgloss ] = avg_loss(mdl,data,labels)
%AVG_LOSS Summary of this function goes here
%   Detailed explanation goes here

numMdls = size(mdl,1);
lossVals = zeros(numMdls,1);

for m = 1:numMdls
    lossVals(m) = loss(mdl{m},data,labels);
end

avgloss = mean(lossVals);

end

