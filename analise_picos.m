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

Ig = grad(I); fs = 11;
F = fspecial('gaussian', [fs fs], 2);
Igf = imfilter(Ig, F, 'same');
[~,p_pos] = findPeaks(Igf,5);
[~,g_pos] = findPeaks(Ig,5);
[~,m_pos] = findPeaks(Imasc,5);
[~,v_pos] = findValleys(Igf,5);

% figure, imshow(Ig);
% hold on, plot(g_pos(:,2),g_pos(:,1),'.g','MarkerSize',5), hold off
figure, imshow(Igf);
hold on, plot(p_pos(:,2),p_pos(:,1),'*g','MarkerSize',2), hold off
% figure, imshow(Imasc);
% hold on, plot(m_pos(:,2),m_pos(:,1),'.g','MarkerSize',5), hold off
figure, imshow(Igf);
hold on, plot(v_pos(:,2),v_pos(:,1),'*y','MarkerSize',2), hold off

figure, imshow(I);
hold on, plot(p_pos(:,2),p_pos(:,1),'*b','MarkerSize',2), hold off
figure, imshow(I);
hold on, plot(v_pos(:,2),v_pos(:,1),'*r','MarkerSize',2), hold off