I = imread('inputs//16.jpg');
Ibw1 = im2bw(I,0.4); %0.2
Ibw2 = im2bw(I,0.75); %0.45
Ig1 = grad(Ibw1);
Ig2 = grad(Ibw2);
idx = Ig2 > 0.1;
Imasc = Ig1.*idx;
Ithin = bwmorph(Imasc,'remove');

figure
subplot(2,2,1), imshow(Ibw1) 
subplot(2,2,2), imshow(Ig1), title('edge')
subplot(2,2,3), imshow(Ibw2)
subplot(2,2,4), imshow(Ig2), title('mask')

figure
subplot(1,2,1), imshow(I)
subplot(1,2,2), imshow(Imasc)

figure, imshow(Ig2), title('mask')
figure, imshow(Ithin), title('thin')
figure, imshow((4*Ithin+Ig2)/5), title('final')


