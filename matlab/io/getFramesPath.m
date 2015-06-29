function frames = getFramesPath(path)
% Carica tutte le path dei frame dalla path padre

if exist(path) ~= 7
    error('myfuns:getFramesPath:fileNotFound',...
        'La cartella non esiste')
end

content = dir(path);
content = sortName(content);

frames = [];

for i = [1:length(content)]
    file_path = fullfile(path, content(i));
    frames = [frames; {file_path}];
end


function sorted = sortName(names)
% Ordina i nomi in base al numero di frame
sorted = cell(size(names,1) - 2, 1);
for i = [1:length(names)]
    if ~(strcmp(names(i).name, '.') || strcmp(names(i).name, '..'))
        splitted = strsplit(names(i).name, '_');
        numberString = splitted{2};
        numberString = strrep(numberString, '.bin', '');
        new_index = str2num(numberString) + 1;
        % Gli indici in matlab partono da 1
        % Complimenti, Matlab!
        sorted{new_index} = names(i).name;
    end
end
