%% Código para extração dos features
%  
% Luiz Henrique Padovani

clear all; close all; clc;

%% Inicialização do programa
fprintf('Programa inicializado...\n'); tic
files = dir('inputs\*.jpg');
N = length(files);                        % número de imagens
np = 16;                                  % número de patches
D  =  7;                                  % tamanho do vetor deslocamento da GLCM
fs = 11;                                  % tamanho do filtro gaussiano
tf = [5, 11];                          % tamanho da janela do peakFinder
energy  = zeros(N*np,4); homoge = zeros(N*np,4); entro     = zeros(N*np,4); 
p_borda = zeros(N*np,2); picos  = zeros(N*np,4); picos_pos = cell(N,4); 
vales   = zeros(N*np,1); vales_pos = cell(N,1);  target    = zeros(N*np,1);
% ----->>> Descrição dos picos:
% * picos(:,1) - contagem de picos no gradiente com filtro gaussiano
% * picos(:,2) - contagem de picos no gradiente com filtro gaussiano e correção de histograma
% * picos(:,3) - contagem de picos no gradiente com filtro passa-baixas ideal no domínio da frequência para tf = 5
% * picos(:,4) - contagem de picos no gradiente com filtro passa-baixas ideal no domínio da frequência para tf = 11 

%% Extração dos features de cada imagem
for id = 1:N
    % Carregamento da imagem
    fileName = sprintf('inputs\\%d.jpg',id);
    I = double(imread(fileName));         % leitura da imagem
    fprintf('\n  -->  Análise da imagem %d.\n', id);
    
    % Carregamento das anotações
    fileName = sprintf('inputs\\%d_ann.mat',id);
    load(fileName);               
    
    % divisão em patches 
    A = a2patch(I, annPoints, np);                  % célula das anotações dividida em patches
    for n = 1:np
        temp = size(cell2mat(A(n)),1);
        target((id-1)*np+n) = temp;
    end
    P = i2patch(I, np);                             % imagem dividida em patches
    [hp, wp, ~] = size(P);                          % dimensões dos patches
    area = hp * wp;                                 % área de cada patch
    Pedge = zeros(hp,wp,np);
    
    %----------------------------------------------------------%
    %% Contagem de pixels na borda
    bw1 = [0.20, 0.40]; bw2 = [0.45, 0.75];
    for k = 1:2
        for n = 1:np  
            Pbw1 = im2bw(P(:,:,n),bw1(k)); Pbw2 = im2bw(P(:,:,n),bw2(k));
            Pbw1_g = Pbw1; Pbw2_g = Pbw2;
            if (sum(Pbw1(:)) ~= 0), Pbw1_g = grad(Pbw1); end
            if (sum(Pbw2(:)) ~= 0), Pbw2_g = grad(Pbw2); end        
            idx = Pbw2_g > 0.1;                 % máscara
            Pmasked = Pbw1_g.*idx;
            Pthin = bwmorph(Pmasked,'remove');
            Pedge(:,:,n) = (4*Pthin+Pmasked)/5;
            p_borda((id-1)*np+n,k) = 1000*sum(Pedge(:))/area;
        end
    end
    
    %----------------------------------------------------------%
    %% Contagem de picos e vales
        %% com filtro gaussiano
    Pg = grad(P); 
    pos_g = []; pos_h = []; pos_v = [];
    idx = Pg > 0.2; Ph = Pg.*idx;
    F = fspecial('gaussian', [fs fs], 2);
    Pgf = imfilter(Pg, F, 'same');
    Phf = imfilter(Ph, F, 'same');
    t = (fs-1)/2;                           % tamanho do raio da vizinhança
    k = 1;
    for n = 1:np
        if k>4
            k = 1;
        end
        [picos((id-1)*np+n,1),pos_g_aux] = findPeaks(Pgf(:,:,n),t);
        picos((id-1)*np+n,1) = picos((id-1)*np+n,1)/area;
        
        [picos((id-1)*np+n,2),pos_h_aux] = findPeaks(Phf(:,:,n),t);
        picos((id-1)*np+n,2) = picos((id-1)*np+n,2)/area;
        
        [vales((id-1)*np+n,1),pos_v_aux] = findValleys(Pgf(:,:,n),t);
        vales((id-1)*np+n,1) = vales((id-1)*np+n,1)/area;
        
        if (size(pos_g_aux,1) ~= 0)
            pos_g_aux(:,1) = pos_g_aux(:,1) + (k-1)*hp;
            pos_g_aux(:,2) = pos_g_aux(:,2) + floor((n-0.1)/sqrt(np))*wp;
        end
        if (size(pos_h_aux,1) ~= 0)
            pos_h_aux(:,1) = pos_h_aux(:,1) + (k-1)*hp;
            pos_h_aux(:,2) = pos_h_aux(:,2) + floor((n-0.1)/sqrt(np))*wp;
        end
        if (size(pos_v_aux,1) ~= 0)
            pos_v_aux(:,1) = pos_v_aux(:,1) + (k-1)*hp;
            pos_v_aux(:,2) = pos_v_aux(:,2) + floor((n-0.1)/sqrt(np))*wp;
        end
        
        pos_g = [pos_g; pos_g_aux];
        pos_h = [pos_h; pos_h_aux];
        pos_v = [pos_v; pos_v_aux];
        
        k = k + 1;
    end
    % posições dos picos
    picos_pos(id,1) = {pos_g}; picos_pos(id,2) = {pos_h}; vales_pos(id,1) = {pos_v};  
    
        %% com FFT e filtro passa-baixas ideal
    FT = fft2(Pedge);                       % obtenção da TF da imagem pré-processada
    Pft = zeros(size(FT));
    for k = 1:np
        Pft(:,:,k) = fftshift(FT(:,:,k));   % centralização da componente DC da TF
    end 
    % criação do filtro passa-baixas
    hr = (hp-1)/2; hc = (wp-1)/2; 
    [xf, yf] = meshgrid(-hc:hc, -hr:hr);
    mg = sqrt((xf/hc).^2 + (yf/hr).^2);
    fc = 0.4;                               % frequência de corte
    lp = double(mg <= fc);
    Pp = zeros(hp,wp,np);
    for k = 1:np 
        Pp(:,:,k) = Pft(:,:,k) .* lp; 
    end 
    Pfilt = abs(ifft2(ifftshift(Pp)));
    
    for k = 1:length(tf)
        pos_f = [];
        conta = 1;
        for n = 1:np
            if conta > 4
                conta = 1;
            end
            [picos((id-1)*np+n,k+2),pos_f_aux] = findPeaks(Pfilt(:,:,n),tf(k));
            picos((id-1)*np+n,k+2) = picos((id-1)*np+n,k+2)/area;            
            if (size(pos_f_aux,1) ~= 0)
                pos_f_aux(:,1) = pos_f_aux(:,1) + (conta-1)*hp;
                pos_f_aux(:,2) = pos_f_aux(:,2) + floor((n-0.1)/sqrt(np))*wp;
            end
            pos_f = [pos_f; pos_f_aux];
            conta = conta + 1;
        end
        % posições dos picos
        picos_pos(id,k+2) = {pos_f};
    end 
    
    %----------------------------------------------------------%
    %% Propriedades da Gray-level co-occurrence matrix
    offset = [0 D; -D D; -D 0; -D -D];
    for n = 1:np
        glcms = graycomatrix(P(:,:,n),'Offset',offset);
        stats = graycoprops(glcms,{'Energy','Homogeneity'});
        
        ent1 = entropy(glcms(:,:,1)); ent2 = entropy(glcms(:,:,2));
        ent3 = entropy(glcms(:,:,3)); ent4 = entropy(glcms(:,:,4));
        entro((id-1)*np+n,1) = sum(ent1(:));
        entro((id-1)*np+n,2) = sum(ent2(:));
        entro((id-1)*np+n,3) = sum(ent3(:));
        entro((id-1)*np+n,4) = sum(ent4(:));

        energy((id-1)*np+n,:) = stats.Energy;
        homoge((id-1)*np+n,:) = stats.Homogeneity;
    end
    
    %----------------------------------------------------------%
    %% Viola-Jones
    % criação de objeto detector de faces
    faceDetector = vision.CascadeObjectDetector;
    faceDetector.MergeThreshold = 6;                % ajuste da confiança do detector  
    
    % aplicação do faceDetector em cada patch da imagem
    for n = 1:np
        bboxes = step(faceDetector, P(:,:,n));
        faces(id,n) = size(bboxes,1);           % #linhas = #faces
    end
    
    
    % MELHORIA futura: aplicar o viola-jones à imagem inteira e depois dividir a
    % localização das faces em cada patch para evitar "faces cortadas"
end

%% Normalização dos features
% normalização dos features da GLCM
for k = 1:4
    energy(:,k) = (energy(:,k) - mean(energy(:,k)))/std(energy(:,k));
    homoge(:,k) = (homoge(:,k) - mean(homoge(:,k)))/std(homoge(:,k));
    entro(:,k)  = (entro(:,k)  - mean(entro(:,k)))/std(entro(:,k));
end
% normalização dos features da contagem de pixels na borda
p_borda(:,1) = (p_borda(:,1) - mean(p_borda(:,1)))/std(p_borda(:,1));
p_borda(:,2) = (p_borda(:,2) - mean(p_borda(:,2)))/std(p_borda(:,2));
% normalização dos features da contagem de picos
for k = 1:size(picos,2)
    picos(:,k)  = (picos(:,k) - mean(picos(:,k)))/std(picos(:,k));
end
% normalização dos features da contagem de picos
vales(:,1)  = (vales(:,1) - mean(vales(:,1)))/std(vales(:,1));

%% Salvando os dados
features = struct('energy', energy, 'entropy', entro, 'homogeneity', homoge,...
    'pixels_borda',p_borda, 'peaks', picos, 'valleys', vales);

save('variaveis.mat','features','target','faces','picos_pos','vales_pos','np','N');
clear

fprintf('\nPrograma finalizado.\n'); toc    % Ending message

