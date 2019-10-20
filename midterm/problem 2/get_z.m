function [zVals, a, b] = get_z(xVals,yVals, sx, sy, nSig, range, K)
%GET_Z Summary of this function goes here

zVals = zeros(length(xVals), length(yVals));

for i = 1:length(xVals)
    x = xVals(i);
    
    for j = 1:length(yVals)
        y = yVals(j);
        A = [x;y];
        xMap = map_val(x, sx, range, nSig, K);
        yMap = map_val(y, sy, range, nSig, K);
        mapVal = [xMap; yMap];
        zVals(j, i) = PriorKnowledge(mapVal, sx, sy);
    end
    
end

end

