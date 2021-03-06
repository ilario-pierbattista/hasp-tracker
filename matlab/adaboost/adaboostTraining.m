function [weakClassifiers, weightedErrors, w, betasT, alphas, samplesSize] = adaboostTraining(datasetPath, numberOfWeakClassifiers, featuresMinimumSizes, featuresStepSizes, precalculateFeatures, scaleFactor, floorValue);
    % ${2/.*/U/} Description
    %    ${1/.*/U/} = ${2/.*/U/}()
    %
    % Long description

    % Apertura del dataset
    datasetPath = checkisdir(datasetPath);
    if datasetPath == false
        error('Path non valida');
    end
    samples = getFrames(datasetPath);
    samplesSize = [samples(1).width, samples(1).height];
    % Inizializzazione dei pesi
    w = initWeights(samples);
    % Setup delle features
    features = setupFeatures(samples, scaleFactor, featuresMinimumSizes, featuresStepSizes);
    fprintf('Rilevate %d configurazioni di feature possibili.\n', size(features, 2));
    % Lettura dei frames e delle etichette
    [frames, labels] = readFramesAndLabels(samples, scaleFactor, floorValue);
    % Inizializzazione degli altri vettori
    weightedErrors = [];
    betasT = [];
    weakClassifiers = [];
    alphas = [];
    % Se precalculateFeatures è true, il valore delle features viene calcolato
    % preventivamente su ogni immagine
    if precalculateFeatures
        tic;
        fprintf('Calcolo del valore delle features\n');
        featuresValues = calculate_features(frames, labels, w, features);
        toc;
    else
        featuresValues = [];
    end

    % Main adaboost Loop
    loopETA = tic;
    fprintf('Inizio del ciclo principale di Adaboost\n');
    T = numberOfWeakClassifiers;
    for t = [1:T]
        % Normalizzazione dei pesi
        w(t,:) = w(t,:) / sum(w(t,:));

        singlePassETA = tic;
        % Estrazione del miglior classificatore debole
        if isempty(featuresValues)
            [h, e, updatedWeights, betaT, fIndex] = best_weak_classifier(frames, labels, w, features);
        else
            [h, e, updatedWeights, betaT, fIndex] = best_weak_classifier(frames, labels, w, features, featuresValues);
        end
        % Rimozione della feature selezionata
        features(:,fIndex) = [];
        if ~isempty(featuresValues)
            featuresValues(:,fIndex) = [];
        end
        toc(singlePassETA);

        fprintf('Weak classifier #%d/%d [%.2f%%]\n', t, T, round(t*10000/T)/100);

        % Aggiornamento dei pesi e dei parametri
        w = [w; updatedWeights];
        betasT = [betasT; betaT];
        weightedErrors = [weightedErrors; e];
        weakClassifiers = [weakClassifiers; h];
        alphas = [alphas; log(1/betaT)];
    end
    toc(loopETA);
end


function w = initWeights(samples);
    % ${2/.*/U/} Inizializzazione dei pesi di ogni campione
    %    ${1/.*/U/} = ${2/.*/U/}()
    %
    % Long description
    [l, m] = countSamples(samples);
    w = [];
    for i = [1: length(samples)]
        if samples(i).positive
            w = [w 1/(2*m)];
        else
            w = [w 1/(2*l)];
        end
    end
end


function [l,m] = countSamples(samples);
    % ${2/.*/U  /} Conta separatamente il numero di esempi positivi ed esempi negativi
    %    ${1/.*/U   /} = ${2/.*/U   /}()
    %
    % Long description
    m = 0; l = 0;
    for i = [1:length(samples)]
        if samples(i).positive
            m = m+1;
        else
            l = l+1;
        end
    end
end
