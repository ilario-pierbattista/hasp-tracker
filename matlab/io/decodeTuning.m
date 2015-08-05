function [thr, cls] = decodeTuning(dataPath);
    [dataPath, isdirectory] = checkpath(dataPath);
    if isempty(dataPath) || ~isdirectory
        error('Path non valida');
    end

    tuningFile = fullfile(dataPath, 'tuning.dat');
    if exist(tuningFile) ~= 2
        error('File di tuning inesistente o non valido');
    end

    data = dlmread(tuningFile);
    thr = data(1);
    cls = data(2);
end
