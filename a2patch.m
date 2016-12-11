function [P] = a2patch(I, A, n)
% This function divides an array of annotated points A in n symmetric patches in respect to the image I. 

[h, w] = size(I);           % image dimensions
l = sqrt(n);                % 
P = cell(n,1);              % cell of patches inicialization

Cx = A(:,1);                % x coordinate of annotatios
Cy = A(:,2);                % y coordinate of annotatios

limx = zeros(1,l+1);        % x coordinates of the patches boundaries
limy = zeros(1,l+1);        % y coordinates of the patches boundaries
for k = 1:l
    limx(k+1) = k*(w/l);
    limy(k+1) = k*(h/l);
end

it = 1;
for k = 1:l
    idx = (( Cx > limx(k)) & (Cx < limx(k+1)));
    for t = 1:l
        idy = (( Cy > limy(t)) & (Cy < limy(t+1)));
        id = idx & idy;
        P(it) = {A(id,:)};
        it = it + 1;
    end
end

end