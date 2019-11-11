function [ normalized_image, reg_img ] = image_normalizer(imgmat)

% find sizes
imgH = size(imgmat, 1);		% image width
imgW = size(imgmat, 2);		% image height

normalized_image = zeros(imgH * imgW, 5);

% loop through imgmat to get the pixel locations and color values
x = 1;
y = 1;
for row = 1:(imgW * imgH)
	normalized_image(row, 1) = x;					% pixel's x location
	normalized_image(row, 2) = y;					% pixel's y location
	normalized_image(row, 3) = imgmat(y, x, 1);		% pixel's r value
	normalized_image(row, 4) = imgmat(y, x, 2);		% pixel's g value
	normalized_image(row, 5) = imgmat(y, x, 3);		% pixel's b value

	% update y
	if mod(row, imgH) == 0
		y = 1;
	else
		y = y + 1;
	end

	% update x iff we've been through all the y's
	if mod(row, imgH) == 0
		x = x + 1;
	elseif x >= imgW
		x = 1;
	end
end
reg_img = normalized_image;		% image values before normalization

% get the normalized column values
norm_length = size(normalized_image, 2);
for aVal = 1:norm_length
	normalized_image(:, aVal) = normalize(normalized_image(:, aVal), ...
	 'range');
end
end