%% Código para treinamento e validação
%  
% Luiz Henrique Padovani

clear all; close all; clc;
load('variaveis2.mat');

energy  = features.energy;
homoge  = features.homogeneity;
entro   = features.entropy;
f_glcm = [energy homoge entro];     %  --> 1 a 12
p_borda = features.pixels_borda;    %  --> 13 e 14
picos   = features.peaks;           %  --> 15 a 22

% Xtotal = [f_glcm p_borda picos];

Xtotal = picos;

for it = 1:size(picos,2)
    %% Aprendizado
    aa = 0.7*N;                               % número de amostras para aprendizado
    X = Xtotal(1:np*aa,it);                    % utilização dos 'aa' primeiros exemplos para treinamento 
    y = target(1:np*aa);
    m = length(y);
    X = [ones(m, 1) X];
    L = eye(size(X,2)); L(1,1) = 0;
    lambda = 0.1;                             % parâmetro de regularização
    theta = (X'*X + lambda*L)\(X'*y);         % equação normal para regressão linear

    %% Teste
    at = N - aa;                              % número de amostras para teste
    heads = zeros(np*at,1);
    for k = 1:np*at                           % utilização dos 'at' últimos exemplos para teste
        heads(k) = [1 Xtotal(np*aa + k,it)]*theta;
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

    %% Avaliação de desempenho
    metrica_mse = mean((x-y).^2);
    metrica_mae = mean(abs(x-y));
    metrica_mde = mean(abs(x-y)./y);
    metrica_nad = mean(abs(x-y)./(sqrt(mean(x)^2+mean(y)^2)));
    metrica = struct('mse',metrica_mse,'mae',metrica_mae,...
               'mde',metrica_mde,'nad',metrica_nad,'cc',cc);

    save('resultados.mat','heads','theta','metrica','aa');
    fprintf('    Métrica   it = %d\n', it)
    disp(metrica)
end
