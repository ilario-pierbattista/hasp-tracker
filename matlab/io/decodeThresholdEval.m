function data = decodeThresholdEval(dataPath);
    [dataPath, isdirectory] = checkpath(dataPath);
    if isempty(dataPath) || ~isdirectory
        error('Path non valida');
    end

    data = struct();
    % Nomi dei files da decodificare
    filesToDecode = {'thresholds', 'accuracy', 'sensitivity', 'specificity', 'mcc'};
    filesExtension = '.dat';

    for i = [1:length(filesToDecode)]
        filename = fullfile(dataPath, strcat(filesToDecode{i}, filesExtension));
        if exist(filename) == 2
            data = setfield(data, filesToDecode{i}, dlmread(filename));
        end
    end
end
