function [ hbe ] = my_interp(ye, ktSeq, utSeq)
%INTERP Get estimates for logitudinal and latitudinal data
%   xen is an estimate for a time at nT
%   ktSeq = known-time sequence
%   utSeq = unknown-time sequence

%% initialize variables
hbe = zeros(size(utSeq,1), 2);   % hbe is an array of zeros (to start)

%% linear interpolation - equation from wikipedia
for i = 1:size(utSeq,1)
    for j = 1:size(ktSeq,1)
        %fprintf('%.0f,%0.f %.0f < %.0f = %.0f\n',i,j,utSeq(i), ktSeq(j), utSeq(i) < ktSeq(j))
        if utSeq(i) < ktSeq(j)  % only want values that sit inbetween other values
            hbe(i,:) = ye(j - 1,:) + ((ye(j,:) - ye(j-1,:)) / ...
                (ktSeq(j) - ktSeq(j-1))) * (utSeq(i) - ktSeq(j-1));
            break
        end
    end
end
end

