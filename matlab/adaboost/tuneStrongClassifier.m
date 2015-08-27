function tuneStrongClassifier(dataPath, param);
    dataPath = checkisdir(dataPath);
    if dataPath == false
        error('Path non valida');
    end

    if nargin == 1
        param = 'mcc';
    end

    folders = struct();
    data = struct();
    global CLASSIFIER_NAMES;

    for name = CLASSIFIER_NAMES
        name = char(name);
        folders = setfield(folders, name, fullfile(dataPath, name));
        evaluation = decodeThresholdEval(getfield(folders, name));
        data = setfield(data, name, evaluation);

        [thr, cls] = getBestTuning(getfield(data, name), param);
        encodeTuning(getfield(folders, name), thr, cls);

        fprintf('Classificatore %s: Threshold: %f NWC: %d\n', name, thr, cls);
    end
end
