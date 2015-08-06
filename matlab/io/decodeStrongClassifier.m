function strongClassifier = decodeStrongClassifier(dataPath);
    [dataPath, isdirectory] = checkpath(dataPath);
    if isempty(dataPath) || ~isdirectory
        error('Path del classificatore forte non valida');
    end

    wc = decodeWeakClassifier(dataPath);
    scaleFactor = dlmread(fullfile(dataPath, 'scaleFactor.dat'));
    samplesSize = dlmread(fullfile(dataPath, 'samplesSize.dat'));
    floorValue = dlmread(fullfile(dataPath, 'floorValue.dat'));
    alphas = dlmread(fullfile(dataPath, 'alphas.dat'));

    alphasum = 0;
    summedAlphaList = [];
    for i = [1:length(alphas)]
        alphasum = alphasum + alphas(i);
        % ogni elemento del seguente array è la somma di tutti gli elementi
        % dell'array alphas precedenti allo stesso indice
        % Utile per calcolare velocemente il classificatore forte utilizzando
        % un diverso numero di classificatori deboli
        summedAlphaList = [summedAlphaList; alphasum];
    end

    thr = -1; cls = -1;
    if exist(fullfile(dataPath, 'tuning.dat')) == 2
        [thr, cls] = decodeTuning(dataPath);
    end

    strongClassifier = struct('weakClassifiers', wc,...
    'scaleFactor', scaleFactor,...
    'samplesSize', samplesSize,...
    'floorValue', floorValue,...
    'alphas', alphas,...
    'alphaSum', alphasum,...
    'summedAlphaList', summedAlphaList,...
    'innerOffset', [0 0],...
    'threshold',thr,...
    'numberOfClassifiers', cls);
end
