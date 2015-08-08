function dirpath = choosesubdir(basepath);
    % choosesubdir Visualizza le sottocartelle contenute in basepath, facendone scegliere una
    content = dir(basepath);
    subfolders = [];
    % Lettura del contenuto della directory
    for i = [1:length(content)]
        if content(i).isdir && ~(strcmp(content(i).name, '.') || strcmp(content(i).name, '..'))
            subfolders = [subfolders; {content(i).name}];
        end
    end
    choosen = false;
    if ~isempty(subfolders)
        while ~choosen
            % Visualizzazione del contentuto della directory
            fprintf('Contenuto della directory:\n');
            for i = [1:length(subfolders)]
                fprintf('%s\t', subfolders{i});
            end
            fprintf('\n');

            subf = input('Sottocartella da utilizzare: ', 's');
            if isempty(subf)
                fprintf('\n');
                continue;
            end
            [dirpath, isdirectory] = checkpath(fullfile(basepath, subf));
            if isempty(dirpath) || ~isdirectory
                fprintf('Directory non valida\n\n');
            else
                choosen = true;
            end
        end
    else
        dirpath = basepath;
    end
end
