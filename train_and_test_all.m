%% C�digo para treinamento e valida��o
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
    aa = 0.7*N;                               % n�mero de amostras para aprendizado
    X = Xtotal(1:np*aa,it);                    % utiliza��o dos 'aa' primeiros exemplos para treinamento 
    y = target(1:np*aa);
    m = length(y);
    X = [ones(m, 1) X];
    L = eye(size(X,2)); L(1,1) = 0;
    lambda = 0.1;                             % par�metro de regulariza��o
    theta = (X'*X + lambda*L)\(X'*y);         % equa��o normal para regress�o linear

    %% Teste
    at = N - aa;                              % n�mero de amostras para teste
    heads = zeros(np*at,1);
    for k = 1:np*at                           % utiliza��o dos 'at' �ltimos exemplos para teste
        heads(k) = [1 Xtotal(np*aa + k,it)]*theta;
    end

    % apresenta��o do gr�fico Heads x Ground Truth
    x = target(np*aa+1:np*N); y = heads;
    x_g = zeros(at,1); y_g = x_g;
    for k = 1:at
        x_g(k) = sum(x(((k-1)*np + 1):k*np)); 
        y_g(k) = sum(y(((k-1)*np + 1):k*np));
    end
    [x,idx] = sort(x_g); y = y_g(idx);
    [cc,~,~] = regression(x,y,'one');
    % figure; plotregression(x,y);

    %% Avalia��o de desempenho
    metrica_mse = mean((x-y).^2);
    metrica_mae = mean(abs(x-y));
    metrica_mde = mean(abs(x-y)./y);
    metrica_nad = mean(abs(x-y)./(sqrt(mean(x)^2+mean(y)^2)));
    metrica = struct('mse',metrica_mse,'mae',metrica_mae,...
               'mde',metrica_mde,'nad',metrica_nad,'cc',cc);

    save('resultados.mat','heads','theta','metrica','aa');
    fprintf('    M�trica   it = %d\n', it)
    disp(metrica)
end
