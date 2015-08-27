% Inizializzazione dell'ambiente
initEnvironment;
clear dataPath;
clear testPath;
clear samples;

global CLASSIFIER_NAMES;
DEFAULT_TESTING_SET = 'TEST1';

% Input della path del classificatore
dataPath = input('Path del classificatore forte: ', 's');
% Input della path del dataset di testing
testPath = inputdef('Path del dataset di testing [%s]: ', DEFAULT_TESTING_SET, 's');
testPath = checkisdir(testPath);
if testPath == false;
    error('Path di testing non valida');
end

finalClassifier = decodeFinalClassifier(dataPath, true);

if checksubdirs(testPath, CLASSIFIER_NAMES)
    test_folder = struct();
    for name = CLASSIFIER_NAMES
        name = char(name);
        test_folder = setfield(test_folder, name, fullfile(testPath, name));
    end
else
    test_folder = testPath;
end

% estrazione dei frames
samples = struct();
frames = struct();
labels = struct();

% Estrazione dei frame
for name = CLASSIFIER_NAMES
    name = char(name);
    if isstruct(test_folder)
        folder = getfield(test_folder, name);
    else
        folder = test_folder;
    end
    samples = setfield(samples, name, getFrames(folder));
    [f, l] = readFramesAndLabels(getfield(samples, name),...
        finalClassifier.scaleFactor, finalClassifier.floorValue);
    frames = setfield(frames, name, f);
    labels = setfield(labels, name, l);
end

% Valutazione delle soglie
thresholds = [0 : 0.01 : 1];
data = struct();
tic;
for name = CLASSIFIER_NAMES
    name = char(name);
    [acc, tpr, tnr, mcc] = evaluate_thresholds(getfield(finalClassifier, name),...
        getfield(frames, name), getfield(labels, name), thresholds);
    d = struct('thresholds', thresholds,...
        'accuracy', acc,...
        'sensitivity', tpr,...
        'specificity', tnr,...
        'mcc', mcc);
    data = setfield(data, name, d);
    encodeThresholdEval(fullfile(dataPath, name), getfield(data, name));
end
fprintf('\n');
toc;

% Estrazione della coppia soglia-numero di classificatori deboli
% che massimizza il parametro mcc
% tuneStrongClassifier(dataPath);
% massimizzazione dell'accuracy
tuneStrongClassifier(dataPath, 'accuracy');
