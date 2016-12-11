%% Código para treinamento e validação
%  
% Luiz Henrique Padovani

clear all; close all; clc;
load('variaveis.mat');

flag = input('Digite 0 para anular negativos. Digite qualquer outro número para não anular negativos. ');

energy  = features.energy;
homoge  = features.homogeneity;
entro   = features.entropy;
p_borda = features.pixels_borda;
picos   = features.peaks;
vales   = features.valleys;

%% Seleção de Features utilizados
% Features disponíveis:
% energy, homogeneity, entropy, #edgepixels, #edgepeaks
texto = ['Escolha dos features utilizados\n'          ...
        ' 1 - GLCM\n'                                 ...
        ' 2 - Pixels de borda bw=0.20/0.45\n'         ...
        ' 3 - Pixels de borda bw=0.40/0.75\n'         ...
        ' 4 - Picos1 (edge)\n'                        ...
        ' 5 - Picos2 (edge+hist)\n'                   ...
        ' 6 - Picos3 (fft)\n'                         ...
        ' 7 - GLCM + borda\n'                         ...
        ' 8 - GLCM + Picos1\n'                        ...
        ' 9 - GLCM + Picos2\n'                        ...
        '10 - GLCM + Picos3\n'                        ...
        '11 - GLCM + borda + Picos1\n'                ...
        '12 - GLCM + borda + Picos2\n'                ...
        '13 - GLCM + borda + Picos3\n'                ...
        '14 - GLCM + borda + Picos(1e3)\n'            ...
        '15 - GLCM + borda + Picos(2e3)\n'            ...
        '16 - GLCM + borda + Picos(1e2)\n'            ...
        '17 - vales\n'                                ...
        '18 - GLCM + vales\n'                         ...
        '19 - GLCM + vales + Picos1\n'                ...
        '20 - GLCM + vales + Picos2\n'                ...
        '21 - GLCM + vales + Picos3\n'                ...
        '22 - GLCM + vales + Picos(1e2)\n'            ...
        '23 - GLCM + vales + borda + Picos(1e3)\n'    ...
        '24 - GLCM + vales + borda + Picos1\n'        ...
        '25 - GLCM + vales + borda + Picos2\n'        ...
        '26 - GLCM + vales + borda + Picos(1e2)\n'    ...
        'outro valor - erro.\n'  ];
    
feat = input(texto);
switch feat
   case 1
      Xtotal = [energy homoge entro]; 
   case 2
      Xtotal = p_borda(:,1);
   case 3
      Xtotal = p_borda(:,2);
   case 4
      Xtotal = picos(:,1); 
   case 5
      Xtotal = picos(:,2);  
   case 6
      Xtotal = picos(:,3);      
   case 7
      Xtotal = [energy homoge entro p_borda(:,1)]; 
   case 8
      Xtotal = [energy homoge entro picos(:,1)];       
   case 9
      Xtotal = [energy homoge entro picos(:,2)];
   case 10
      Xtotal = [energy homoge entro picos(:,3)];     
   case 11
      Xtotal = [energy homoge entro p_borda(:,1) picos(:,1)];  
   case 12
      Xtotal = [energy homoge entro p_borda(:,1) picos(:,2)];
   case 13
      Xtotal = [energy homoge entro p_borda(:,1) picos(:,3)];
   case 14
      Xtotal = [energy homoge entro p_borda(:,1) picos(:,1) picos(:,3)];    
   case 15
      Xtotal = [energy homoge entro p_borda(:,1) picos(:,2) picos(:,3)]; 
   case 16
      Xtotal = [energy homoge entro p_borda(:,1) picos(:,1) picos(:,2)]; 
   case 17
       Xtotal = vales;
   case 18
       Xtotal = [energy homoge entro vales];
   case 19
       Xtotal = [energy homoge entro vales picos(:,1)];
   case 20
       Xtotal = [energy homoge entro vales picos(:,2)];
   case 21
       Xtotal = [energy homoge entro vales picos(:,3)];
   case 22
       Xtotal = [energy homoge entro vales picos(:,1) picos(:,2)];
   case 23
      Xtotal = [energy homoge entro p_borda(:,1) vales picos(:,1) picos(:,3)]; 
   case 24
      Xtotal = [energy homoge entro p_borda(:,1) vales picos(:,1)];
   case 25
      Xtotal = [energy homoge entro p_borda(:,1) vales picos(:,2)];
   case 26
      Xtotal = [energy homoge entro p_borda(:,1) vales picos(:,1) picos(:,2)]; 
   otherwise
      keyboard      
end

%% Aprendizado
aa = 0.7*N;                               % número de amostras para aprendizado
X = Xtotal(1:np*aa,:);                    % utilização dos 'aa' primeiros exemplos para treinamento 
y = target(1:np*aa);
m = length(y);
X = [ones(m, 1) X];
L = eye(size(X,2)); L(1,1) = 0;
lambda = 0.1;                             % parâmetro de regularização
theta = (X'*X + lambda*L)\(X'*y);         % equação normal para regressão linear

%% Teste
at = N - aa;                              % número de amostras para teste
heads = zeros(np*at,1);
% fprintf('Ground Truth\t\t\tHeads\n');
for k = 1:np*at                           % utilização dos 'at' últimos exemplos para teste
    heads(k) = [1 Xtotal(np*aa + k,:)]*theta;
%     fprintf('   %d   \t\t\t  %.2f  \n', target(k+np*aa), heads(k));
end

% anular contagens negativas
if (flag == 0)
    idxn = heads > 0;
    heads = heads.*idxn;
end

% apresentação do gráfico Heads x Ground Truth
x = target(np*aa+1:np*N); y = heads;
x_g = zeros(at,1); y_g = x_g;
for k = 1:at
    x_g(k) = sum(x(((k-1)*np + 1):k*np)); 
    y_g(k) = sum(y(((k-1)*np + 1):k*np));
end
[x,idx] = sort(x_g); y = y_g(idx);
[cc,~,~] = regression(x,y,'one');
% figure; plotregression(x,y);
x = x_g; y = y_g;
%% Avaliação de desempenho
metrica_mse = mean((x-y).^2);
metrica_mae = mean(abs(x-y));
metrica_mde = mean(abs(x-y)./y);
metrica_nad = mean(abs(x-y)./(sqrt(mean(x)^2+mean(y)^2)));
metrica = struct('mse',metrica_mse,'mae',metrica_mae,...
           'mde',metrica_mde,'nad',metrica_nad,'cc',cc);
keyboard;
save('resultados.mat','heads','theta','metrica','aa','feat','flag');
disp('    Métrica')
disp(metrica)
