function [ flag ] = overlap( x1,y1,w1,h1,x2,y2,w2,h2)
%OVERLAP This function returns true if there is an overlap between the two
%input rectangles and false if there is not.
%   The origin of each rectangle is passed as (x,y) and their dimensions as
%   (w,h). The origin is the extreme top left point.
flag = 0;
for x = x2:(x2+w2)
    for y = y2:(y2+h2)
        if(x > x1 && x < (x1+w1) && y > y1 && y < (y1 + h1))
            flag = 1;
            break;
        end
    end
    if (flag == 1)
        break;
    end
end

end

