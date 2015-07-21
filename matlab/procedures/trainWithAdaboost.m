initEnvironment;
%definizione di costanti nel codice
T = 50;
% Il valore del pavimento al centro dell'inquadratura
floorValue = 2850;

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

% Esecuzione di adaboost
[weakClassifiers, weightedErrors, w, betasT, alphas] = adaboostTraining('DBX', T, fmin, fstep, true, 4, floorValue);

% Salvataggio dei risultati
folder = strcat('strong_classifier_',datestr(now, 'DD-mmm-YYYY_HH:MM:SS'));
mkdir(folder);
dlmwrite(fullfile(folder, 'weakClassifiers.dat'), weakClassifiers);
dlmwrite(fullfile(folder, 'weightedErrors.dat'), weightedErrors);
dlmwrite(fullfile(folder, 'weights.dat'), w);
dlmwrite(fullfile(folder, 'betasT.dat'), betasT);
dlmwrite(fullfile(folder, 'alphas.dat'), alphas);
fprintf('Risultati salvati nella cartella %s\n', folder);
