load('variaveis.mat');
im = input('escolha a imagem: '); 
name = sprintf('inputs//%d.jpg', im);
I = imread(name);


    pos_g = cell2mat(picos_pos(im,1));
    pos_h = cell2mat(picos_pos(im,2));
% picos do gradiente
    fig = figure; imshow(uint8(I));
    hold on, plot(pos_g(:,2),pos_g(:,1),'.b','MarkerSize',5), hold off
    name = sprintf('outputs\\%d_g.png', im);
    saveas(fig,name); close all;
    
    % picos do gradiente com correção de histograma 
    fig = figure; imshow(uint8(I));
    hold on, plot(pos_h(:,2),pos_h(:,1),'.b','MarkerSize',5), hold off
    name = sprintf('outputs\\%d_h.png', im);
    saveas(fig,name); close all;