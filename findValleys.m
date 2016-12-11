function [valley,valley_positions] = findValleys(A, neighbourhood)
%Não filtra nada.
%Considera como vale SE SOMENTE SE o ponto for maior do que TODOS os
%vizinhos.

valley_positions = [];
valley = 0;

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
        bloco(1 + neighbourhood,1+neighbourhood) = Inf;
                
        curr_pixel = A(i,j);
        min_neighbourhood = min(min(bloco));
        if (curr_pixel < min_neighbourhood)
            valley = valley + 1;
            valley_positions = [valley_positions ; i j];
        end        
    end
end

