% strongClassifierTuning.m
%
% Ricerca e memorizzazione dei parametri che massimizzano le prestazioni
% dell'algoritmo di riconoscimento.
% I parametri interessati sono:
% * valore di soglia del classificatore forte;
% * il numero di classificatori deboli da utilizzare.


% Inizializzazione dell'ambiente
initEnvironment;
clear dataPath;

% Input della path del classificatore
dataPath = input('Path del classificatore forte: ', 's');
tuneStrongClassifier(dataPath, 'accuracy');
