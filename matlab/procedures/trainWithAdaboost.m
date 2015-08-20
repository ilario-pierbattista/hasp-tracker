initEnvironment;
format long g;
%definizione di costanti nel codice
T = 200;
% Il valore del pavimento al centro dell'inquadratura
% Non essendo costante in tutti i punti, ho preferito valuturlo al centro
% dell'inquadratura ed impostarlo a mano.
floorValue = KINECT_V2_FLOOR_VALUE;

% dimensioni minime delle features
fmin = [2 4; 4 2; 2 6; 6 2];
%fmin = [4 8; 8 4; 4 12; 12 4];
%fmin = [8 8; 8 8; 8 12; 12 8];

% step incremento delle features
fstep = [1 2; 2 1; 1 3; 3 1];
%fstep = [2 2; 2 2; 2 3; 3 2];
%fstep = [2 4; 4 2; 2 6; 6 2];
%fstep = [4 4; 4 4; 4 6; 6 4];

% Le immagini vengono ridimensionate
% precedentemente
scaleFactor = 1;
%scaleFactor = 2;
%scaleFactor = 4;

classifiersName = {'x' 'y'};

% Nomi delle cartelle per i risultati
folder = strcat('strong_classifier_',datestr(now, 'DDmmmYYYYHHMMSS'));
trainingFolder = checkpath('TRAINING1');

for name = classifiersName
    trainingData = fullfile(trainingFolder, char(name));
    outputFolder = fullfile(folder, name);
    [weakClassifiers, weightedErrors, w, betasT, alphas, samplesSize] = adaboostTraining(trainingData,...
        T, fmin, fstep, true, scaleFactor, floorValue);
    if ~exist(folder)
        mkdir(folder);
    end
    mkdir(outputFolder);
    encodeWeakClassifier(outputFolder, weakClassifiers, weightedErrors,...
    w, betasT, alphas, scaleFactor, samplesSize, floorValue);
end

fprintf('Risultati salvati nella cartella %s\n', folder);
