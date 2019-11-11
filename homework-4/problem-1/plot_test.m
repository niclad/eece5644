szPlane = size(planeNorm, 1);

for i = 1:szPlane
    plot(planeNorm(i,1), planeNorm(i,2), '.', 'MarkerFaceColor', ...
        [planeNorm(i,3), planeNorm(i,4), planeNorm(i,5)])
    hold on
end
