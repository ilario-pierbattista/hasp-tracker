% Inizializzazione dell'ambiente
initEnvironment;
clear dataPath;
clear testPath;
clear samples;

classifierNames = ['x', 'y'];
DEFAULT_TESTING_SET = 'TRAINING1';

% Input della path del classificatore
dataPath = input('Path del classificatore forte: ', 's');
% Input della path del dataset di testing
testPath = inputdef('Path del dataset di testing [%s]: ', DEFAULT_TESTING_SET, 's');
testPath = checkisdir(testPath);
if testPath == false;
    error('Path di testing non valida');
end

% Se sono presenti le sottocartelle con gli stessi nomi dei classificatori
% allora bisogna usare una sottocartella per ogni classificatore
if checksubdirs(testPath, classifierNames)
    % Decodicia del classificatore finale senza l'applicazione dell'offset
    % Ogni cartella, infatti, deve contenere frame di allenamento della
    % dimensione del classificatore forte
    finalClassifier = decodeFinalClassifier(dataPath, true);
else
    finalClassifier = decodeFinalClassifier(dataPath);
end

% estrazione dei frames
samples = struct();
frames = struct();
labels = struct();

% Estrazione dei frame
for name = classifierNames
    samples = setfield(samples, name, getFrames(fullfile(testPath, name)));
    [f, l] = readFramesAndLabels(getfield(samples, name),...
        finalClassifier.scaleFactor, finalClassifier.floorValue);
    frames = setfield(frames, name, f);
    labels = setfield(labels, name, l);
end

% Valutazione delle soglie
thresholds = [0 : 0.01 : 1];
data = struct();
tic;
for name = classifierNames
    [acc, tpr, tnr, mcc] = evaluateThresholds(getfield(finalClassifier, name),...
        getfield(frames, name), getfield(labels, name), thresholds);
    d = struct('thresholds', thresholds,...
        'accuracy', acc,...
        'sensitivity', tpr,...
        'specificity', tnr,...
        'mcc', mcc);
    data = setfield(data, name, d);
    encodeThresholdEval(fullfile(dataPath, name), getfield(data, name));
end
toc;

% Estrazione della coppia soglia-numero di classificatori deboli
% che massimizza il parametro mcc
% tuneStrongClassifier(dataPath);
% massimizzazione dell'accuracy
tuneStrongClassifier(dataPath, 'accuracy');
