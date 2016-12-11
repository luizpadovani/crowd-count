function [peaks,peak_positions] = findPeaks(A, neighbourhood)
%Não filtra nada.
%Considera como pico SE SOMENTE SE o ponto for maior do que TODOS os
%vizinhos.

peak_positions = [];
peaks = 0;

if (nargin == 1)
    neighbourhood = 1;
end


[m, n] = size(A);

i_start = 1 + neighbourhood;
i_end   = m - neighbourhood;
j_start = 1 + neighbourhood;
j_end   = n - neighbourhood;

for i = i_start:1:i_end
    for j = j_start:1:j_end
        bloco = A(i - neighbourhood: i + neighbourhood, j - neighbourhood: j + neighbourhood);
        bloco(1 + neighbourhood,1+neighbourhood) = -Inf;
                
        curr_pixel = A(i,j);
        max_neighbourhood = max(max(bloco));
        if (curr_pixel > max_neighbourhood)
            peaks = peaks + 1;
            peak_positions = [peak_positions ; i j];
        end        
    end
end

