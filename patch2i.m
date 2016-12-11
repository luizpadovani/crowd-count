function [R] = patch2i(K)
% This function constructs an image from n symmetric patches. 
    it = 1; flag = 1;
    sz = size(K);
    h = sz(1); w = sz(2);
    
    if (length(sz) == 3)
        np = sz(3);
        flag = 0;
    elseif (length(sz) == 4)
        d = sz(3);
        np = sz(4);
    else
        disp('Matrix de patches deve ter dimensão 3 ou 4.')
        keyboard;
    end
    
    l = sqrt(np); h = l*h; w = l*w;
    
    if (flag == 0)
        R = zeros(h,w);
    else
        R = zeros(h,w,d);
    end
    
    limx = zeros(1,l+1);
    limy = zeros(1,l+1);
    for k = 1:l
        limx(k+1) = k*(w/l);
        limy(k+1) = k*(h/l);
    end
    for n = 1:l
        idx = limx(n)+1:limx(n+1);
        for m = 1:l
            idy = limy(m)+1:limy(m+1);
            if (flag == 0)
                R(idy,idx) = K(:,:,it);
            else
                R(idy,idx,:) = K(:,:,:,it);
            end
            it = it + 1;
        end
    end
    
    if (flag == 1)
        R = uint8(R);
    end

end