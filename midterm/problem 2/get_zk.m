function [zVals] = get_zk(vals, sx, sy, nSig, range, K)
%GET_Z Summary of this function goes here

zVals = zeros(length(vals), length(vals));

for i = 1:K
    x = vals(i, 1);
    for j = 1:K
        y = vals(j, 2);
        A = [x;y];
        xMap = map_val(x, sx, range, nSig, 1);
        yMap = map_val(y, sy, range, nSig, 1);
        mapVal = [xMap; yMap];
        zVals(j, i) = norm(mapVal - A);%PriorKnowledge(mapVal, sx, sy);
    end
end

end

