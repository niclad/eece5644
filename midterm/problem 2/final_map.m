function tMin = final_map(vals,range, nSig, sx, sy, K)
%FINAL_MAP Summary of this function goes here
%   Detailed explanation goes here
fun = @(t) map_function(vals, t(1), t(2), range, nSig, sx, sy, K);

tGuess = [0.25;sin(acos(0.25))];
tMin = fminsearch(fun, tGuess);
end

