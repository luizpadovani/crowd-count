function [D] = i2patch(I, n)
% This function divides an image I in n symmetric patches. 
I = double(I);
[h, w, ~] = size(I);        % image dimensions
l = sqrt(n);                % 
D = zeros(h/l,w/l,n);       % cell of patches inicialization

limx = zeros(1,l+1);        % x coordinates of the patches boundaries
limy = zeros(1,l+1);        % y coordinates of the patches boundaries
for k = 1:l
    limx(k+1) = k*w/l;
    limy(k+1) = k*h/l;
end

it = 1;
for k = 1:l
    idx = limx(k)+1:limx(k+1);
    for t = 1:l
        idy = limy(t)+1:limy(t+1);
        D(:,:,it) = I(idy,idx);
        it = it + 1;
    end
end

D = uint8(D);

end