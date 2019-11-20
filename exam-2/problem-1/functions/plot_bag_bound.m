function plot_bag_bound(mdls)
%PLOT_BAG_BOUND Summary of this function goes here
%   Detailed explanation goes here

x1range = -4:.01:4;
x2range = x1range;
[xx1, xx2] = meshgrid(x1range,x2range);
xgrid = [xx1(:) xx2(:)];
gridLabels = bag_predict(mdls, xgrid);

gscatter(xx1(:), xx2(:), gridLabels,[0.5 1 0.5; 0.5 0.5 1]);
legend off

% set the gird being the boundaries
ax = gca;
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.Layer = 'top';
end


