function [ z ] = optimal_eq(x,y,sx,sy,si,K,landmarks)
%OPTIMAL_EQ Summary of this function goes here
%   Detailed explanation goes here

z = zeros(size(x,1),size(y,2));

for i = 1:size(x,1)
    for j = 1:size(y,1)
        B = (x(i,j)^2) / (sx^2) + (y(i,j)^2) / (sy^2);
        A = 0;
        for m = 1:K
            ri  = landmarks(m,3);
            dti = norm(landmarks(m,1:2) - [x(i,j),y(i,j)]);
            A = A + ( (ri - dti)^2 / (si^2) );
        end
        z(i,j) = -A - B;
    end
end
end