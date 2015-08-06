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

% Decodifica del classificatore finale
finalClassifier = decodeFinalClassifier(dataPath);
% estrazione dei frames
samples = getFrames(testPath);
[frames, labels] = readFramesAndLabels(samples, finalClassifier.scaleFactor, finalClassifier.floorValue);

[tp, tn, fp, fn] = adaboostTesting(finalClassifier, frames, labels);
[sensitivity, specificity, accuracy, mcc] = calculateEvaluationParams(tp, tn, fp, fn)
