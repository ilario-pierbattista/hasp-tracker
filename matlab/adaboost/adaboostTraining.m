function [weakClassifiers, weightedErrors, w, betasT, alphas] = adaboostTraining(datasetPath, numberOfWeakClassifiers, featuresMinimumSizes, featuresStepSizes, precalculateFeatures, scaleFactor, floorValue)
% ${2/.*/U/} Description
%    ${1/.*/U/} = ${2/.*/U/}()
%
% Long description

% Apertura del dataset
samples = getTrainingFrames(getRealPath(datasetPath));
% Inizializzazione dei pesi
w = initWeights(samples);
% Setup delle features
features = setupFeatures(samples, scaleFactor, featuresMinimumSizes, featuresStepSizes);
fs = size(features);
fprintf('Rilevate %d features possibili.', fs(2));
input('Premere invio per continuare');
% Lettura dei frames e delle etichette
[frames, labels] = readFramesAndLabels(samples, scaleFactor);
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
    % Rimozione della feature selezionata da quelle esistenti
    features(:,fIndex) = [];
    featuresValues(:,fIndex) = [];
    toc(singlePassETA);

    fprintf('Weak classifier #%d/%d [%d%%]\n', t, T, round(t*10000/T)/100);

    % Aggiornamento dei pesi e dei parametri
    w = [w; updatedWeights];
    betasT = [betasT; betaT];
    weightedErrors = [weightedErrors; e];
    weakClassifiers = [weakClassifiers; h];
    alphas = [alphas; log(1/betaT)];
end
toc(loopETA);


function w = initWeights(samples)
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


function [l,m] = countSamples(samples)
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


function features = setupFeatures(samples, scaleFactor, featuresMinimumSizes, featuresStepSizes)
% ${2/.*/U/} Imposta le combinazioni possibili di features
%    ${1/.*/U/} = ${2/.*/U/}()
%
% Imposta le combinazioni possibili di features all'interno dell'area di
% visualizzazione, tenendo conto della dimensione minima di ciascun tipo di
% feature e del passo di incremento della dimensione della stessa.
[width, height] = getDimensions(samples);
if scaleFactor > 1
    width = round(width / scaleFactor);
    height = round(height / scaleFactor);
end
features = transpose(get_features([width height], featuresMinimumSizes, featuresStepSizes));


function image = preprocessImage(sample, scaleFactor)
% ${2/.*/U/} Preprocessa un'immagine
%    ${1/.*/U/} = ${2/.*/U/}()
%
% Long description
image = readImageData(sample.filepath, sample.width, sample.height, 16);
if scaleFactor > 1
    image = scale_image(image, scaleFactor);
end
image = floor_rebase(image);
image = integral_image(image);


function [frames, labels] = readFramesAndLabels(samples, scaleFactor)
% ${2/.*/U/} Effettua le operazioni di preprocessing sugli elementi del
% database di allenamento
%    ${1/.*/U/} = ${2/.*/U/}()
%
% Long description
[width, height] = getDimensions(samples);
if scaleFactor > 1
    height = round(height/scaleFactor);
    width = round(width/scaleFactor);
end
frames = zeros(height, width, length(samples));
labels = [];
for i = [1:length(samples)]
    frames(:,:,i) = preprocessImage(samples(i), scaleFactor);
    labels = [labels samples(i).positive];
end


function path = getRealPath(pathname)
% ${2/.*/U/} Description
%    ${1/.*/U/} = ${2/.*/U/}()
%
% Long description

if ~isempty(getenv(pathname))
    path = getenv(pathname);
else
    path = pathname;
end
if exist(path) ~= 7
    error('Path non valida\n');
end


function [w, h] = getDimensions(samples)
w = samples(1).width;
h = samples(1).height;
