function [bboxes, N, ver] = dfpv(bboxes, detector, I)
% Detailed False Positive Verification
% 
% 
N = size(bboxes,1);  % gives the number of bboxes
ver = 0;
    for n = 1:N
        x = bboxes(n,1);
        y = bboxes(n,2);
        dx = bboxes(n,3);
        dy = bboxes(n,4);
        alpha = 0.75;           % -----------> define best value 
        xi = round(x - alpha*dx);
        xf = round(x + (1+alpha)*dx);
        yi = round(y - alpha*dy);
        yf = round(y + (1+alpha)*dy);
        if (xi < 1)
            xi = 1;
        end
        if (yi < 1)
            yi = 1;
        end
        if (xf > size(I,2))
            xf = size(I,2);
        end
        if (yf > size(I,1))
            yf = size(I,1);
        end 
        crop = I(yi:yf,xi:xf,:);        % crop of the bigger picture
        detailed_box = step(detector, crop);
        if (size(detailed_box,1) == 0)
            bboxes(n,:) = 0;
            ver = [ver,n];
        end
    end
    
    % Update
    ver = ver(2:end);
    bboxes = bboxes(any(bboxes,2),:);
    N = size(bboxes,1);
    
end