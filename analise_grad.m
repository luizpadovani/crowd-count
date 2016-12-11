I = imread('inputs//42.jpg');
Ig = grad(I);
idx = Ig > 0.2;
Ih = Ig.*idx;
 
fs = 11; t = (fs-1)/2;
H = fspecial('gaussian', [fs fs], 2);

Igf = imfilter(Ig, H, 'same');
[picos_g,pic_pos_g] = findPeaks(Igf,t);
Ihf = imfilter(Ih, H, 'same');
[picos_h,pic_pos_h] = findPeaks(Ihf,t);

figure
subplot(2,2,1), imshow(Ig)  , title('grad')
subplot(2,2,2), imshow(Ih)  , title('grad+hist')
subplot(2,2,3), imshow(Igf) , title('grad+filt')
subplot(2,2,4), imshow(Ihf) , title('grad+hist+filt')

figure
subplot(1,2,1), imshow(I)
hold on, plot(pic_pos_g(:,2),pic_pos_g(:,1),'.g','MarkerSize',5), hold off
name = sprintf('grad+filt    picos = %d',picos_g); title(name)
subplot(1,2,2), imshow(I)
hold on, plot(pic_pos_h(:,2),pic_pos_h(:,1),'.g','MarkerSize',5), hold off
name = sprintf('grad+hist+filt    picos = %d',picos_h); title(name)


