clear
clc

% Get all jpg files in the specified folder
files = dir('C:\Users\LuizH\Documents\MATLAB\Processamento_Imagens\Face_Detection\lvl1_unresized\*.jpg');

% Loop through each
for id = 1:length(files)
    fileName = sprintf('C:\\Users\\LuizH\\Documents\\MATLAB\\Processamento_Imagens\\Face_Detection\\lvl1_unresized\\%d.jpg',id);
    
    % Read Image
    I = imread(fileName);
    
    % Resize Image
    J = imresize(I, [500 NaN]);
    
    name = sprintf('%d.jpg', id);
    imwrite(J,name);
end
