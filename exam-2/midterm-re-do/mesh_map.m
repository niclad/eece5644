function [ am ] = mesh_map(x,y,r,tp,si, data,sx,sy)
%MESH_MAP Summary of this function goes here
%   Detailed explanation goes here

dti = vecnorm(tp' - data, 2,2);
A = (r - dti).^2;
A = A ./ (2*si^2);
A = sum(A);
s = inv([sx^2 0; 0 sy^2]);
am = zeros(size(x,1), size(y,1));

for i = 1:length(x)
    for j = 1:length(y)
        th = [x(i,j);y(i,j)];
        am(i,j) = -A - (th'*s*th) / 2;
    end
end
end


