function landmarks = k_vals(K)
% get inital k placement values as a percent
% will be used to find location as a percent of circumference
kLoc = repmat(rand, 1, K);
for i = 1:K
    kLoc(i) = kLoc(i) + ((1/K) * i);
    if kLoc(i) > 1
        kLoc(i) = kLoc(i) - 1;
    end
    
    kLoc(i) = 2 * pi * kLoc(i); % get percent of circumference
    % this value can be used to get x and y coordinates from sin and cos
    % ie x = cos(kLoc(i)); y = sin(kLoc(i));
end
kLocX = cos(kLoc); % K x values
kLocY = sin(kLoc); % K y values
landmarks = [kLocX', kLocY'];
end

