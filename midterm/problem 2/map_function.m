function minned = map_function(vals, x, y, range, nSig, sx, sy,K)
%MAP_FUNCTION Summary of this function goes here
%   Detailed explanation goes here

xi = vals(:, 1);
yi = vals(:, 1);
covMat = [sx^2, 0; 0, sy^2];


sumT = 0;
for i = 1:K
    sumT = sumT + ((range(i) - norm([x;y] - [xi(i);yi(i)]))^2/(2*nSig^2));
end

minned = sumT + ([x,y]*inv(covMat)*[x;y])/2;

end

