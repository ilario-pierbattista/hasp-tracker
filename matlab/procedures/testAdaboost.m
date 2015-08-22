% testAdaboost.m
% Testing generale delle prestazioni dell'algoritmo.

% Inizializzazione dell'ambiente
initEnvironment;
clear dataPath;
clear testPath;
clear samples;

% Input della path del classificatore
dataPath = input('Path del classificatore forte: ', 's');

% Input della path del dataset di testing
testPath = inputdef('Path del dataset di allenamento [%s]: ', 'TEST1', 's');
testPath = checkisdir(testPath);
if testPath == false
    error('Path di testing non valida');
end

% Decodifica del classificatore finale
finalClassifier = decodeFinalClassifier(dataPath);
% estrazione dei frames
samples = getFrames(testPath);
[frames, labels] = readFramesAndLabels(samples, finalClassifier.scaleFactor, finalClassifier.floorValue);

[tp, tn, fp, fn] = test_classifier(finalClassifier, frames, labels);
[sensitivity, specificity, accuracy, mcc] = calculateEvaluationParams(tp, tn, fp, fn)
