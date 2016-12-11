clear
clc

% Get all jpg files in the current folder
files = dir('*.jpg');

% Loop through each
for id = 1:length(files)
    movefile(files(id).name, sprintf('%d.jpg', id));
end
