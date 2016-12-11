 %% Apresentação dos Resultados
clear all; close all; clc;
load('variaveis.mat');
l = sqrt(np);
energy  = features.energy;
homoge  = features.homogeneity;
entro   = features.entropy;
ang = 2;
for id = 23:23
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
        text_str = { ['ene = ' num2str(energy((id-1)*np + n,ang),3) ''];...
                     ['ent = ' num2str(entro((id-1)*np + n,ang),3) ''];...
                     ['hom = ' num2str(homoge((id-1)*np + n,ang),3) '']};
        RGB(:,:,:,n) = insertText(P(:,:,n),position,text_str,'FontSize',18,'BoxColor',...
        box_color,'BoxOpacity',0.4,'TextColor','white');
    end
    
    enet = sum(energy((id-1)*np+1:id*np));          % energia total na imagem
    entt = sum(entro((id-1)*np+1:id*np));          % entropia total na imagem
    homt = sum(homoge((id-1)*np+1:id*np));          % homogeneidade total na imagem
    
    fig = figure; Ia = patch2i(RGB);
%     name = sprintf('Figura %d\nenergia = %.2f    entropia = %.2f    homogeneidade = %.2f', id, enet, entt, homt);
    imshow(Ia), %title(name);
    hold on
    idxh = (1:hp:h);
    idxw = (1:wp:w);
    for n = 1:l
        plot(idxw(n)*[1, 1],[1, h],'y');
        plot([1, w],idxh(n)*[1, 1],'y');
    end
    hold off
    
    name = sprintf('figuras\\glcm_%d_%d.png', id, ang);
    saveas(fig,name);
    close all;
end