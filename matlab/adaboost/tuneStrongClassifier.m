function tuneStrongClassifier(dataPath);
    [dataPath, isdirectory] = checkpath(dataPath);
    if isempty(dataPath) || ~isdirectory
        error('Path non valida');
    end
    folders = struct();
    data = struct();
    classNames = {'x', 'y', 'o1', 'o2'};

    for i = [1:length(classNames)]
        name = classNames{i};
        folders = setfield(folders, name, fullfile(dataPath, name));
        evaluation = decodeThresholdEval(getfield(folders, name));
        data = setfield(data, name, evaluation);

        [thr, cls] = getBestTuning(getfield(data, name));
        encodeTuning(getfield(folders, name), thr, cls);

        fprintf('Classificatore %s: Threshold: %f NWC: %d\n', name, thr, cls);
    end
end