function [bboxes, N] = overlap_ver(bboxes, detector, I)
% % Overlap Verification
% 
% 
N = size(bboxes,1);  % gives the number of bboxes

t = 1;
for n = 1:N
    for m = t:N
        overlap_flag = overlap(bboxes(n,1),bboxes(n,2),bboxes(n,3),...
            bboxes(n,4),bboxes(m,1),bboxes(m,2),bboxes(m,3),bboxes(m,4));
        if (n == m)
           continue;                             
        end
        if (overlap_flag == 1)
            xi = min(bboxes(n,1),bboxes(m,1));
            xf = max(bboxes(n,1) + bboxes(n,3),bboxes(m,1) + bboxes(m,3));
            yi = min(bboxes(n,2),bboxes(m,2));
            yf = max(bboxes(n,2) + bboxes(n,4),bboxes(m,2) + bboxes(m,4));
            crop = I(yi:yf, xi:xf, :);
            detailed_box = step(detector, crop);
            M = size(detailed_box,1);
            if (M == 0)
                fprintf('Face não encontrada na verificação de overlap.\n')
            elseif (M > 1)
                fprintf('A verificação de overlap encontrou %d faces neste recorte.\n', M)
            else
                bboxes(m,:) = 0;
                fprintf('O overlap foi corrigido.\n')
            end
        end
    end
    
    t = t + 1;
    
end
 
% Update
bboxes = bboxes(any(bboxes,2),:);
N = size(bboxes,1);
end