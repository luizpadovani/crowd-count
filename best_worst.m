%% Definição dos melhores e dos piores casos

clear all; close all; clc;
load('variaveis.mat'); load('resultados.mat');

y = zeros(15,1);
y_est = zeros(15,1);

% anulando contagens negativas
if (flag == 0)
    idxn = heads > 0;
    heads = heads.*idxn;
end

for k = 36:50
   y(k-35)     = sum(target(((k-1)*np + 1):k*np));
   y_est(k-35) = sum(heads(((k-36)*np + 1):(k-35)*np));
end

error = abs(y - y_est);
error_n = abs(y - y_est)./y;

[e_min, e_min_idx] = min(error);
[e_max, e_max_idx] = max(error);

[e_min_n, e_min_idx_n] = min(error_n);
[e_max_n, e_max_idx_n] = max(error_n);

fprintf('Imagem com erro mínimo: %d\n',e_min_idx+35); 
fprintf('Imagem com erro máximo: %d\n',e_max_idx+35); 

fprintf('Imagem com erro mínimo normalizado: %d\n',...
    (e_min_idx_n+35)); 
fprintf('Imagem com erro máximo normalizado: %d\n',...
    (e_max_idx_n+35));


[y_s, idx_y] = sort(y);
y_est_s = y_est(idx_y);

error1 = abs(y_s(1:5) - y_est_s(1:5));
error2 = abs(y_s(6:10) - y_est_s(6:10));
error3 = abs(y_s(11:15) - y_est_s(11:15));

media1 = mean(y_s(1:5));
media2 = mean(y_s(6:10));
media3 = mean(y_s(11:15));

M_mae1 = mean(error1);
M_mae2 = mean(error2);
M_mae3 = mean(error3);

M_mae = [M_mae1 M_mae2 M_mae3];
media = [media1 media2 media3];

bar(media,M_mae);
xlabel('Contagem real média');
ylabel('MAE');