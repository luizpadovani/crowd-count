im = input('escolha a imagem: '); 
name = sprintf('inputs//%d.jpg', im);
I = imread(name);
bw1 = 0.2;              %0.2 ou 0.4
bw2 = 0.45;             %0.45 ou 0.75
Ibw1 = im2bw(I,bw1); 
Ibw2 = im2bw(I,bw2); 
Ig1 = grad(Ibw1);
Ig2 = grad(Ibw2);
idx = Ig2 > 0.1;
Imasc = Ig1.*idx;
Ithin = bwmorph(Imasc,'remove');
n1 = sprintf('BW1 = %.2f', bw1);
n2 = sprintf('BW2 = %.2f', bw2);

fig = figure; imshow(I),               title('I original')
name = sprintf('figuras\\%d_1_%.2f_%.2f.png', im, bw1,bw2);
saveas(fig,name); close all;
fig = figure; imshow(grad(I)),         title('I grad')
name = sprintf('figuras\\%d_2_%.2f_%.2f.png', im, bw1,bw2);
saveas(fig,name); close all;
fig = figure; imshow(Ibw1),            title(n1)
name = sprintf('figuras\\%d_3_%.2f_%.2f.png', im, bw1,bw2);
saveas(fig,name); close all;
fig = figure; imshow(Ig1),             title('Ig1 - edge1')
name = sprintf('figuras\\%d_4_%.2f_%.2f.png', im, bw1,bw2);
saveas(fig,name); close all;
fig = figure; imshow(Ibw2),            title(n2)
name = sprintf('figuras\\%d_5_%.2f_%.2f.png', im, bw1,bw2);
saveas(fig,name); close all;
fig = figure; imshow(Ig2),             title('Ig2 - edge2 (mask)')
name = sprintf('figuras\\%d_6_%.2f_%.2f.png', im, bw1,bw2);
saveas(fig,name); close all;
fig = figure; imshow(Imasc),           title('Ig1 masked')
name = sprintf('figuras\\%d_7_%.2f_%.2f.png', im, bw1,bw2);
saveas(fig,name); close all;
fig = figure; imshow(Ithin),           title('Imasked thined')
name = sprintf('figuras\\%d_8_%.2f_%.2f.png', im, bw1,bw2);
saveas(fig,name); close all;
fig = figure; imshow((4*Ithin+Ig2)/5), title('I final')
name = sprintf('figuras\\%d_9_%.2f_%.2f.png', im, bw1,bw2);
saveas(fig,name); close all;