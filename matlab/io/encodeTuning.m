function encodeTuning(dataPath, thr, cls);
    [dataPath, isdirectory] = checkpath(dataPath);
    if isempty(dataPath) || ~isdirectory
        error('Path non valida');
    end
    dlmwrite(fullfile(dataPath, 'tuning.dat'), [thr; cls], 'precision', '%.10f');
end
