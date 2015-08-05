% Inizializzazione dell'ambiente
initEnvironment;
clear dataPath;

% Input della path del classificatore
dataPath = input('Path del classificatore forte: ', 's');
tuneStrongClassifier(dataPath);
