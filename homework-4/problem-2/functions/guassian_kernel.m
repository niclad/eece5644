function [ phi ] = guassian_kernel(x1, x2, sigma)
%GUASSIAN_KERNEL The Gaussian kernel (as a func in Matlab)
%   Detailed explanation goes here

phi = exp(norm(x1-x2)^2 / (2 * sigma^2));

end

