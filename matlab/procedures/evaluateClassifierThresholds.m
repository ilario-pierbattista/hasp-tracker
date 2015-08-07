% Inizializzazione dell'ambiente
initEnvironment;
clear dataPath;
clear testPath;
clear samples;

classifierNames = {'x', 'y', 'o1', 'o2'};
DEFAULT_TESTING_SET = 'DB1';

% Input della path del classificatore
dataPath = input('Path del classificatore forte: ', 's');
% Input della path del dataset di testing
promptStr = sprintf('Path del dataset di allenamento [%s]: ', DEFAULT_TESTING_SET);
testPath = input(promptStr, 's');
if isempty(testPath)
    testPath = getenv(DEFAULT_TESTING_SET);
end
[testPath, isdirectory] = checkpath(testPath);
if isempty(testPath) || ~isdirectory
    error('Path di testing non valida');
end

% Decodicia del classificatore finale
finalClassifier = decodeFinalClassifier(dataPath, true);

% estrazione dei frames
samples = struct();
frames = struct();
labels = struct();
for i = [1:length(classifierNames)]
    % Decodifica del dataset
    samples = setfield(samples,...
    classifierNames{i},...
    getFrames(fullfile(testPath, classifierNames{i})));
    [f, l] = readFramesAndLabels(getfield(samples, classifierNames{i}),...
    finalClassifier.scaleFactor,...
    finalClassifier.floorValue);
    frames = setfield(frames, classifierNames{i}, f);
    labels = setfield(labels, classifierNames{i}, l);
end

% Valutazione delle soglie
thresholds = [0 : 0.01 : 1];
accuracy = struct();
sensitivity = struct();
specificity = struct();

data = struct();

tic;
for i = [1:length(classifierNames)]
    [acc, tpr, tnr, mcc] = evaluateThresholds(getfield(finalClassifier, classifierNames{i}),...
    getfield(frames, classifierNames{i}),...
    getfield(labels, classifierNames{i}),...
    thresholds);
    d = struct('thresholds', thresholds,...
    'accuracy', acc,...
    'sensitivity', tpr,...
    'specificity', tnr,...
    'mcc', mcc);
    data = setfield(data, classifierNames{i}, d);
    encodeThresholdEval(fullfile(dataPath, classifierNames{i}),...
    getfield(data, classifierNames{i}));
end
toc;

tuneStrongClassifier(dataPath);
