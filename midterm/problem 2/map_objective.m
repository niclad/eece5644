function mapVal = map_objective(A, range, sigma, K)
%MAP_OBJECTIVE Summary of this function goes here

summation = 0;
for i = 1:K
    summation = summation + (range(i) - norm );
end

end

