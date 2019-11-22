 function [zVals, a, b] = get_z(xVals,yVals, sx, sy, nSig, range)
%GET_Z Summary of this function goes here

zVals = zeros(length(xVals), length(yVals));

for i = 1:length(xVals)
    x = xVals(i);
    
    for j = 1:length(yVals)
        y = yVals(j);
        A = [x;y];
%         xMap = map_val(x, sx, range, nSig, 1);
%         yMap = map_val(y, sy, range, nSig, 1);
        
        mapVal = final_map(A, range, nSig, sx, sy, 1);
        zVals(i, j) = norm(mapVal - A);%PriorKnowledge(mapVal, sx, sy); %norm(mapVal - A);
    end
    
end

end

