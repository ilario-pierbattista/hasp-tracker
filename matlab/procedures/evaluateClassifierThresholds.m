% Inizializzazione dell'ambiente
initEnvironment;
clear dataPath;
clear testPath;
clear samples;

% Input della path del classificatore
dataPath = input('Path del classificatore forte: ', 's');
% Input della path del dataset di testing
testPath = input('Path del dataset di allenamento [TEST1]: ', 's');
if isempty(testPath)
    testPath = getenv('TEST1');
end
[testPath, isdirectory] = checkpath(testPath);
if isempty(testPath) || ~isdirectory
    error('Path di testing non valida');
end

% estrazione dei frames
samples = getFrames(testPath);
windowSize = struct('width', samples(1).width,...
'height', samples(1).height);

% Decodicia del classificatore finale
finalClassifier = decodeFinalClassifier(dataPath);

[frames, labels] = readFramesAndLabels(samples, finalClassifier.scaleFactor, finalClassifier.floorValue);

% Valutazione delle soglie
thresholds = [0 : 0.01 : 1];
accuracy = struct();
sensitivity = struct();
specificity = struct();

data = struct();

tic;
if(isfield(finalClassifier, 'x'))
    [acc, tpr, tnr, mcc] = evaluateThresholds(finalClassifier.x, frames, labels, thresholds);
    data.x = struct('thresholds', threshold,...
    'accuracy', acc,...
    'sensitivity', tpr,...
    'specificity', tnr,...
    'mcc', mcc);
end
if(isfield(finalClassifier, 'y'))
    [acc, tpr, tnr, mcc] = evaluateThresholds(finalClassifier.y, frames, labels, thresholds);
    data.y = struct('thresholds', threshold,...
    'accuracy', acc,...
    'sensitivity', tpr,...
    'specificity', tnr,...
    'mcc', mcc);
end
if(isfield(finalClassifier, 'o1'))
    [acc, tpr, tnr, mcc] = evaluateThresholds(finalClassifier.o1, frames, labels, thresholds);
    data.o1 = struct('thresholds', threshold,...
    'accuracy', acc,...
    'sensitivity', tpr,...
    'specificity', tnr,...
    'mcc', mcc);
end
if(isfield(finalClassifier, 'o2'))
    [acc, tpr, tnr, mcc] = evaluateThresholds(finalClassifier.o2, frames, labels, thresholds);
    data.o2 = struct('thresholds', threshold,...
    'accuracy', acc,...
    'sensitivity', tpr,...
    'specificity', tnr,...
    'mcc', mcc);
end
toc;

% Salvataggio dei risultati
classnames = fieldnames(data);
for i = [1:length(classnames)]
    encodeThresholdEval(fullfile(dataPath, classnames{i}), getfield(data, classnames{i}));
end

tuneStrongClassifier(dataPath);
