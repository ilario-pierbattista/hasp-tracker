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
samples = getTrainingFrames(testPath);
windowSize = struct('width', samples(1).width,...
'height', samples(1).height);
[frames, labels] = readFramesAndLabels(samples, finalClassifier.scaleFactor, finalClassifier.floorValue);
% Conteggio dei positivi e dei negativi
positivesNum = sum(labels == 1);
negativesNum = sum(labels == 0);

% Decodicia del classificatore finale
finalClassifier = decodeFinalClassifier(dataPath, windowSize);

% Valutazione del classificatore x
if isfield(finalClassifier, 'x')
    thresholds = [0 : 0.01 : 1];
    numberOfClassifiers = length(finalClassifier.x.weakClassifiers);
    % True positives rate
    sensitivity = zeros(length(thresholds), numberOfClassifiers);
    % True negative rate
    specificity = zeros(length(thresholds), numberOfClassifiers);
    % Corrects / Total
    accuracy = zeros(length(thresholds), numberOfClassifiers);

    % Per ognuna soglia
    for i = [1:length(thresholds)]
        % Per ogni lunghezza del classificatore forte
        for j = [1:numberOfClassifiers]
            tp = 0;
            tn = 0;
            value = 0;
            for k = [1:length(samples)]
                % Classificazione dell'esempio
                [presence, value] = calculate_strong_classifier(frames(:,:,k), finalClassifier.x, thresholds(i), [0 0], value, j);

                if presence && labels(k)
                    tp = tp + 1;
                elseif ~presence && ~labels(k)
                    tn = tn + 1;
                end
            end

            sensitivity(i,j) = tp / positivesNum;
            specificity(i,j) = tn / negativesNum;
            accuracy(i,j) = (tp + tn) / (positivesNum + negativesNum);

            fprintf('Soglia: %.2f, T: %d\nsensitivity: %f, specificity: %f, accuracy: %f\n', thresholds(i), j, sensitivity(i,j), specificity(i,j), accuracy(i,j));
        end
    end
end
