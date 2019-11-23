function [ dataSet ] = mesh_data(x,y)
%MESH_DATA Summary of this function goes here
%   Detailed explanation goes here
nx = length(x);
ny = length(y);

dataSet = zeros(nx*ny, 2);

for i = 1:nx
    tempX = x(i);
    for j = 1:ny
        tempY = y(j);
        dataSet(i, 1) = tempX;
        dataSet(j, 2) = tempY;
    end
end

end

