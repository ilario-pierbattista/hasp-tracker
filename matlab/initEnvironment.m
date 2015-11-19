% Deprecato
setenv('DATASET_ROOT', '/home/ilario/Documenti/Tirocinio/Dataset/DataBaseKinect/FindPerson/KinectLab/');

% Path del dataset di allenamento
setenv('TRAINING1', '/home/ilario/Documenti/Tirocinio/Training/resized/');

% Path del dataset di validazione
setenv('TEST1', '/home/ilario/Documenti/Tirocinio/Testing/1/24_24/');
setenv('TEST2', '/home/ilario/Documenti/Tirocinio/Testing/2');

% Path delle cartelle con i frame delle registrazioni
setenv('REG1', '/home/ilario/Documenti/Tirocinio/Registrazioni/V2/1/');
setenv('REG2', '/home/ilario/Documenti/Tirocinio/Registrazioni/V2/2/');
setenv('REG3', '/home/ilario/Documenti/Tirocinio/Registrazioni/V2/3/');
setenv('REG4', '/home/ilario/Documenti/Tirocinio/Registrazioni/V2/4/');
setenv('REG5', '/home/ilario/Documenti/Tirocinio/Registrazioni/V2/5/');
setenv('REG6', '/home/ilario/Documenti/Tirocinio/Registrazioni/V2/6/');
setenv('REG7', '/home/ilario/Documenti/Tirocinio/Registrazioni/V2/7/');
setenv('REG8', '/home/ilario/Documenti/Tirocinio/Registrazioni/V2/8/');
setenv('REG9', '/home/ilario/Documenti/Tirocinio/Registrazioni/V2/9/');
setenv('REG10', '/home/ilario/Documenti/Tirocinio/Registrazioni/V2/10/');

% Path con le registrazioni dei falsi
setenv('FALSE1', '/home/ilario/Documenti/Tirocinio/Registrazioni/Falses-V2/1/');
setenv('FALSE2', '/home/ilario/Documenti/Tirocinio/Registrazioni/Falses-V2/2/');
setenv('FALSE3', '/home/ilario/Documenti/Tirocinio/Registrazioni/Falses-V2/3/');
setenv('FALSE4', '/home/ilario/Documenti/Tirocinio/Registrazioni/Falses-V2/4/');
setenv('FALSE5', '/home/ilario/Documenti/Tirocinio/Registrazioni/Falses-V2/5/');
setenv('FALSE6', '/home/ilario/Documenti/Tirocinio/Registrazioni/Falses-V2/6/');
setenv('FALSE7', '/home/ilario/Documenti/Tirocinio/Registrazioni/Falses-V2/7/');
setenv('FALSE8', '/home/ilario/Documenti/Tirocinio/Registrazioni/Falses-V2/8/');

% Valore misurato con il Kinect della distanza del dispositivo dal pavimento
KINECT_V2_FLOOR_VALUE = 2850;

% Categorie globali di classificatori forti (cfr: tesi, capitolo su Adaboost)
global CLASSIFIER_NAMES
CLASSIFIER_NAMES = {'x', 'y'};

% Quantitativo minimo di detection window positive per considerare l'ipotesi
% accettabile (valore empirico)
FALSE_POSITIVE_WINDOWS_THRESHOLD = 7;

% Granulosità nello sliding della finestra di riconoscimento (valore empirico)
global DETECTION_GRANULARITY;
DETECTION_GRANULARITY = 5;

% Largezza in pixel del bordo del frame da considerare per le rilevazioni
% su registrazioni reali a regime
global FRAMEWORK_BORDER_WIDTH;
FRAMEWORK_BORDER_WIDTH = DETECTION_GRANULARITY;

% Distanza, dall'attuale posizione dell'umano in pixel, entro la quale cercare
% la presenza dell'umano nell'instante successivo
global HUMAN_NEIGHBORHOOR_RADIUS;
HUMAN_NEIGHBORHOOR_RADIUS = DETECTION_GRANULARITY*6;
