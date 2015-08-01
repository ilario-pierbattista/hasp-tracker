initEnvironment;
format long g;
%definizione di costanti nel codice
T = 200;
% Il valore del pavimento al centro dell'inquadratura
floorValue = KINECT_V2_FLOOR_VALUE;

% dimensioni minime delle features
fmin = [
    2 4;
    4 2;
    2 6;
    6 2
];
% step incremento delle features
fstep = [
    1 2;
    2 1;
    1 3;
    3 1
];

% Altre configurazioni di gruppi di features
fmin = [4 8; 8 4; 4 12; 12 4];
% fstep = [1 2; 2 1; 1 3; 3 1];
fstep = [2 2; 2 2; 2 3; 3 2];

scaleFactor = 4;

% Nomi delle cartelle per i risultati
folder = strcat('strong_classifier_',datestr(now, 'DD-mmm-YYYY_HH-MM-SS'));
folderx = fullfile(folder, 'x');
foldery = fullfile(folder, 'y');
foldero1 = fullfile(folder, 'o1');
foldero2 = fullfile(folder, 'o2');

% X
% Esecuzione di adaboost
[weakClassifiers, weightedErrors, w, betasT, alphas, samplesSize] = adaboostTraining('DBX', T, fmin, fstep, true, scaleFactor, floorValue);
% Salvataggio dei risultati
mkdir(folder);
mkdir(folderx);
encodeWeakClassifier(folderx, weakClassifiers, weightedErrors, w, betasT, alphas, scaleFactor, samplesSize, floorValue);

% Y
[weakClassifiers, weightedErrors, w, betasT, alphas, samplesSize] = adaboostTraining('DBY', T, fmin, fstep, true, scaleFactor, floorValue);
mkdir(foldery);
encodeWeakClassifier(foldery, weakClassifiers, weightedErrors, w, betasT, alphas, scaleFactor, samplesSize, floorValue);

% O1
[weakClassifiers, weightedErrors, w, betasT, alphas, samplesSize] = adaboostTraining('DBO1', T, fmin, fstep, true, scaleFactor, floorValue);
mkdir(foldero1);
encodeWeakClassifier(foldero1, weakClassifiers, weightedErrors, w, betasT, alphas, scaleFactor, samplesSize, floorValue);

% O2
[weakClassifiers, weightedErrors, w, betasT, alphas, samplesSize] = adaboostTraining('DBO2', T, fmin, fstep, true, scaleFactor, floorValue);
mkdir(foldero2);
encodeWeakClassifier(foldero2, weakClassifiers, weightedErrors, w, betasT, alphas, scaleFactor, samplesSize, floorValue);

fprintf('Risultati salvati nella cartella %s\n', folder);
