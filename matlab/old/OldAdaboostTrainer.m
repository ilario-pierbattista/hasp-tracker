initEnvironment;
fprintf('Questo script sta usando il primo database di allenamento\n');
samples = getFrames(getenv('DB1'));

%definizione di costanti nel codice
T = 50;

% Conteggio dei sample negativi e positivi
m = 0; l = 0;
for i = [1:length(samples)]
    if samples(i).positive
        m = m+1;
    else
        l = l+1;
    end
end

% Inizializzazione dei pesi
w = [];
for i = [1: length(samples)]
    if samples(i).positive
        w = [w 1/(2*m)];
    else
        w = [w 1/(2*l)];
    end
end

% dimensioni minime delle features
fmin = [
    24 24;
    24 24;
    24 24;
    24 24
];
% step incremento delle features
fstep = [
    8 16;
    16 8;
    8 24;
    24 8
];

%fstep = [4 8; 8 4; 4 12; 12 4];

% Calcolo di tutte le combinazioni di features
width = samples(1).width;
height = samples(1).height;
features = transpose(get_features([width height], fmin, fstep));

% preprocessing delle immagini
frames = zeros(height, width, length(samples));
labels = [];
for i = [1:length(samples)]
    image = readImageData(samples(i).filepath, samples(i).width, samples(i).height, 16);
    image = floor_rebase(image);
    image = integral_image(image);
    frames(:,:,i) = image;
    labels = [labels samples(i).positive];
end
betasT = [];
weightedErrors = [];
weakClassifiers = [];
alphas = [];

% fprintf('Calcolo iniziale del valore delle features\n');
featuresValues = calculate_features(frames, labels, w, features);
size(featuresValues)
size(features)

fprintf('Inizio di Adaboost\n');
% Main loop
loopETA = tic;
for t = [1:T]
    % Normalizzazione dei pesi
    w(t,:) = w(t,:) / sum(w(t,:));

    singlePassETA = tic;
    [h, e, updatedWeights, betaT, fIndex] = best_weak_classifier(frames, labels, w, features, featuresValues);
    % [h, e, updatedWeights, betaT] = best_weak_classifier(frames, labels, w, features, featuresValues);
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

% Salvataggio dei risultati
folder = strcat('strong_classifier_',datestr(now, 'DD-mmm-YYYY_HH:MM:SS'));
mkdir(folder);
dlmwrite(fullfile(folder, 'weakClassifiers.dat'), weakClassifiers);
dlmwrite(fullfile(folder, 'weightedErrors.dat'), weightedErrors);
dlmwrite(fullfile(folder, 'weights.dat'), w);
dlmwrite(fullfile(folder, 'betasT.dat'), betasT);
dlmwrite(fullfile(folder, 'alphas.dat'), alphas);
fprintf('Risultati salvati nella cartella %s\n', folder);
