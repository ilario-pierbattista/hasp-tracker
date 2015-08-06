function samples = getFrames(framesPath);
    [framesPath, isdirectory] = checkpath(framesPath);
    if isempty(framesPath) || ~isdirectory
        error('myfuns:getFrames:fileNotFound',...
            'La cartella non esiste');
    end
    negatives = fullfile(framesPath, 'negatives');
    positives = fullfile(framesPath, 'positives');
    if exist(negatives) ~= 7 || exist(positives) ~= 7
        error('myfuns:getFrames:badArgument',...
            'La cartella non contiene un database di allenamento valido');
    end

    neg = dir(negatives);
    pos = dir(positives);
    neg = sortName(negatives, neg);
    pos = sortName(positives, pos);
    samples = [neg; pos];
end

function sorted = sortName(framesPath, names);
    sorted = [];
    for i = [1:length(names)]
        if ~(strcmp(names(i).name, '.') || strcmp(names(i).name, '..'))
            splitted = strsplit(names(i).name, '_');
            pathname = fullfile(framesPath, names(i).name);
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
end
