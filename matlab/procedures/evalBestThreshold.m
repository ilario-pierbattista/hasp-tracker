% Inizializzazione dell'ambiente
initEnvironment;
clear dataPath;
clear testPath;
clear samples;

% Input della path del classificatore
dataPath = input('Path del classificatore forte: ', 's');
[dataPath, isdirectory] = checkpath(dataPath);
if isempty(dataPath) || ~isdirectory
    error('Path non valida');
end

% Input della path del dataset di testing
testPath = input('Path del dataset di allenamento [TEST1]: ', 's');
if isempty(testPath)
    testPath = getenv('TEST1');
end
[testPath, isdirectory] = checkpath(testPath);
if isempty(testPath) || ~isdirectory
    error('Path non valida');
end

% Lettura dei file del classificatore forte
scaleFactor = dlmread(fullfile(dataPath, 'scaleFactor.dat'));

% estrazione dei frames
samples = getTrainingFrames(testPath);
[frames, labels] = readFramesAndLabels(samples, scaleFactor);
