function samples = getTrainingFrames(path)
if exist(path) ~= 7
    error('myfuns:getTrainingFrames:fileNotFound',...
        'La cartella non esiste')
end

negatives = fullfile(path, 'negatives');
positives = fullfile(path, 'positives');
if exist(negatives) ~= 7 || exist(positives) ~= 7
    error('myfuns:getTrainingFrames:badArgument',...
        'La cartella non contiene un database di allenamento valido');
end

neg = dir(negatives);
pos = dir(positives);
neg = sortName(negatives, neg);
pos = sortName(positives, pos);
samples = [neg; pos];


function sorted = sortName(path, names)
sorted = [];
for i = [1:length(names)]
    if ~(strcmp(names(i).name, '.') || strcmp(names(i).name, '..'))
        splitted = strsplit(names(i).name, '_');
        pathname = fullfile(path, names(i).name);
        positive = false;
        if strcmp(splitted(5), 'true.bin')
            positive = true;
        end
        id = str2double(splitted(2));
        width = str2double(splitted(3));
        height = str2double(splitted(4));
        sorted = [sorted; struct('filepath', pathname, 'positive', positive, 'id', id, 'width', width, 'height', height) ];
    end
end
