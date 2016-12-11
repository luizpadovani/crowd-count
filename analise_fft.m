im = input('escolha a imagem: '); 
name = sprintf('inputs//%d.jpg', im);
I = imread(name);
Ift = fftshift(fft2(double(I)));
[ir,ic] = size(I); 
hr = (ir-1)/2; 
hc = (ic-1)/2; 
[x, y] = meshgrid(-hc:hc, -hr:hr);
mg = sqrt((x/hc).^2 + (y/hr).^2); 
fc = 0.35;
lp = double(mg >= fc);
Ip = Ift .* lp; 
% figure, imshow(log(real(Ip)), [0 10])
Ifilt = abs(ifft2(ifftshift(Ip)));
[picos,pic_pos] = findPeaks(Ifilt,9);
figure, imshow(uint8(Ifilt));
figure, imshow(I)
hold on, plot(pic_pos(:,2),pic_pos(:,1),'.g','MarkerSize',5), hold off