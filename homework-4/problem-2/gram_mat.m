function [ G ] = gram_mat(data, kern)
%GRAM_MAT Calculate Gram matrix for defined kernel
%   kern is passed as a function handle:
%   @gaussian_kernel, or
%   @linear_kernel

nSamples = size(data,1);

G = zeros(nSamples);
for i = 1:nSamples
    for j = 1:nSamples
        G(i,j) = kern(data(i,:), data(j,:));
    end
end
end

