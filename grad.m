function [Gn] = grad(I)
%GRAD 
%   This function calculates the gradient of an image using the sobel
%   operator. The output image is in double format.

h = (-1)*fspecial('sobel');
A = double(I);
Gx = imfilter(A,h);
Gy = imfilter(A,h');

G = abs(Gx) + abs(Gy);

Gn = (G - min(G(:)))/(max(G(:) - min(G(:))));
end

