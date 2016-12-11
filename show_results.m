 %% Apresentação dos Resultados
clear all; close all; clc;
load('variaveis.mat'); load('resultados.mat');
files = dir('inputs\*.jpg');
N = length(files);                        % número total de imagens
Ntrain = aa;                              % número total de imagens para treinamento
Ntest = N - Ntrain;                       % número de imagens para teste
l = sqrt(np);

    % ROUBATE
%     idxt = target(aa*np+1:end) ~= 0;
%     heads = heads.*idxt;
%    não é roubate
    idxn = heads > 0;
    heads = heads.*idxn;

    hct = zeros(15,1);
    
for id = Ntrain+1:N;
    % Carregamento da imagem
    fileName = sprintf('inputs\\%d.jpg',id);
    I = double(imread(fileName));         % leitura da imagem
    [h, w] = size(I);
    P = i2patch(I, np);
    [hp, wp, ~] = size(P);
    RGB = zeros(hp, wp, 3, np);
    position = [10 10; 10, 40; 10 70];    
    box_color = {'red','green','blue'};
    
    for n = 1:np
        text_str = { ['fc = ' num2str(faces(id,n)) ''];...
                     ['hc = ' num2str(floor(heads((id-Ntrain-1)*np + n))) ''];...
                     ['gt = ' num2str(target((id-1)*np + n)) '']};
        RGB(:,:,:,n) = insertText(P(:,:,n),position,text_str,'FontSize',18,'BoxColor',...
        box_color,'BoxOpacity',0.4,'TextColor','white');
    end
    
    fct = sum(faces(id,1:np));                           % faceCount total na imagem
    hct(id - Ntrain,1) = sum(heads((id-Ntrain-1)*np+1:(id-Ntrain)*np)); % headCount total na imagem
    gtt = sum(target((id-1)*np+1:id*np));                % groundTruth total na imagem
%     disp(floor(hct))
%     keyboard
    fig = figure; Ia = patch2i(RGB);
    name = sprintf('Figura %d    fc = %d    hc = %d    gt = %d', id, fct, floor(hct(id-Ntrain,1)), gtt);
    imshow(Ia), title(name);
    hold on
    idxh = (1:hp:h);
    idxw = (1:wp:w);
    for n = 1:l
        plot(idxw(n)*[1, 1],[1, h],'y');
        plot([1, w],idxh(n)*[1, 1],'y');
    end
    hold off
    
    name = sprintf('outputs\\%d_%d.png', id, feat);
%     name = sprintf('outputs\\%d_all.png', id);
    saveas(fig,name);
    close all;
%     
    %% Salva as imagens com os picos
%     pos_g = cell2mat(picos_pos(id,1));
%     pos_h = cell2mat(picos_pos(id,2));
%     
%     % picos do gradiente
%     fig = figure; imshow(uint8(I));
%     hold on, plot(pos_g(:,2),pos_g(:,1),'.g','MarkerSize',5), hold off
%     name = sprintf('outputs\\%d_g.png', id);
%     saveas(fig,name); close all;
%     
%     % picos do gradiente com correção de histograma 
%     fig = figure; imshow(uint8(I));
%     hold on, plot(pos_h(:,2),pos_h(:,1),'.g','MarkerSize',5), hold off
%     name = sprintf('outputs\\%d_h.png', id);
%     saveas(fig,name); close all;

%     % picos do gradiente no fundo preto
%     fig = figure; imshow(zeros(h,w));
%     hold on, plot(pos_g(:,2),pos_g(:,1),'.y','MarkerSize',4), hold off
%     hold on, plot(pos_h(:,2),pos_h(:,1),'.g','MarkerSize',5), hold off
%     name = sprintf('outputs\\%d_b.png', id);
%     saveas(fig,name); close all;
end