function samples = getFrames(framesPath, dimension);
    framesPath = checkisdir(framesPath);
    if framesPath == false
        error('La path non esiste o non punta ad una cartella');
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
            file_parts = strsplit(names(i).name, '.');
            file_name = char(file_parts(1));
            splitted = strsplit(file_name, '_');
            pathname = fullfile(framesPath, names(i).name);
            id = str2double(splitted(2));
            width = str2double(splitted(3));
            height = str2double(splitted(4));
            if strcmp(splitted(5), 'true')
                positive = true;
            else
                positive = false;
            end
            data = struct('filepath', pathname, 'positive', positive,...
                'id', id, 'width', width, 'height', height);
            if length(splitted) == 7
                tlx = str2double(splitted(6));
                tly = str2double(splitted(7));
                data = struct('filepath', pathname, 'positive', positive,...
                    'id', id, 'width', width, 'height', height,...
                    'x', tlx, 'y', tly);
            end
            sorted = [sorted; data];
        end
    end
end
