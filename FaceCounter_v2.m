% Human counter in images 
% Luiz Henrique Padovani
% Last Update: 30/11/2016
clear
clc

fprintf('Programa inicializado...\n');

files = dir('inputs2\*.jpg');
N = length(files);                 % Number of images

mth = input('selecione um valor para o merge threshold: ');
% Create faceDetector object
faceDetector = vision.CascadeObjectDetector;
faceDetector.MergeThreshold = mth;                % ajuste da confiança do detector  

% Loop through each image
for id = 1:N
    fileName = sprintf('inputs2\\%d.jpg',id);
    
    % Read Image
    I = imread(fileName);
    fprintf('\nAnálise da imagem %s:\n', fileName);
    
    % Use faceDetector on the image I and get the faces
    bboxes_f = step(faceDetector, I);
    Nf = size(bboxes_f,1);
    fprintf('Número de faces encontradas: %d\n', Nf);
    
    % Detailed False Positive Verification
    [bboxes_f, Nf] = dfpv(bboxes_f, faceDetector,I);
    fprintf('Número de faces encontradas após verificação detalhada de falsos positivos: %d\n', Nf);
    
    % Overlap Verification
    [bboxes_f, Nf] = overlap_ver(bboxes_f, faceDetector, I);
    fprintf('Número de faces encontradas após verificação de overlaps: %d\n', Nf);
    
    % Write Annotated Images
    IFaces = insertObjectAnnotation(I, 'rectangle', bboxes_f,'Face');
    name = sprintf('outputs2\\%d.png', id);
    imwrite(IFaces,name);
end

fprintf('\nPrograma finalizado.\n');


