% Procedura di visualizzazione dei frame registrati con il Kinect
% Inizializzazione dell'ambiente
clear framesPath;
initEnvironment;

% Inserimento della path
framesPath = input('Percorso (o variabile globale che contiene la path) dei frames: ', 's');
framesPath = checkisdir(framesPath);
if framesPath == false
    error('La path dei frames non è valida');
end
% Scelta della sottocartella (se presente) con i frames
framesPath = choosesubdir(framesPath);

% Inserimento della dimensione dei frames
width = inputdef('Larghezza [%d]: ', 512);
height = inputdef('Altezza [%d]: ', 424);
multiple_frames = inputdef('Analizzare più frame presenti nella cartella? [Y/n]:', 'y', 's');
if strcmp(multiple_frames, 'n') || strcmp(multiple_frames, 'N')
    multiple_frames = false;
    frame_index = inputdef('Indice del frame da analizzare [%d]: ', 1);
else
    framestep = inputdef('Intervallo con cui analizzare i frame [%d]: ', 20);
    if framestep < 1
        framestep = 1;
    end
    % Se viene analizzato fino ad un frame ogni 3, la sequenza dei frame è
    % abbastanza scorrevole per attivare il meccanismo di rilevamento con memoria.
    % Vengono analizzati, cioè, solamente le aree più interessanti
    detection_with_memory = (framestep <= 3);
    multiple_frames = true;
end

% Estrazione delle path di tutti i frames
framesFiles = getFramesPath(framesPath);

% Input della path del classificatore
classifierPath = input('Path del classificatore forte: ', 's');
% Decodifica del classificatore finale
finalClassifier = decodeFinalClassifier(classifierPath);

rectangles = [];
f1 = figure;
im1 = imagesc();

if multiple_frames
    indexes = [1:framestep:length(framesFiles)];
else
    indexes = [frame_index];
end

first_iteration = true;
humans = [];

for i = indexes
    tic;
    % Lettura e preprocessing del frame
    frame = readImageData(char(framesFiles{i}), width, height, 16);
    processedFrame = preprocessImage(frame,...
        finalClassifier.scaleFactor,...
        finalClassifier.floorValue);

    rectbox = [];
    % Per il momento la dimensione delle finestre di riconoscimento è fissa
    % È necessario un algoritmo migliore di selezione della finstra vincente
    % per utilizzare finestre di diverse dimensioni
    % @TODO
    layers = create_layers(finalClassifier, 150, 150);
    for classifier = transpose(layers);
        positions = generate_positions([size(processedFrame, 2) size(processedFrame, 1)], classifier.samplesSize,...
            humans, DETECTION_GRANULARITY, first_iteration);
        rectbox = [rectbox; detect_positive_windows(processedFrame, classifier, positions)];
    end
    fprintf('Detected %d positive windows\t', size(rectbox, 1));

    % Se ci sono troppi pochi rettangoli, si scarta a priori il risultato
    % in quanto si potrebbe trattare di un falso positivo
    if size(rectbox, 1) <= FALSE_POSITIVE_WINDOWS_THRESHOLD
        winner_windows = [];
        fprintf('Rejected\t');
    else
        winner_windows = filter_rectangles(rectbox, humans);
        % Calcolo con media aritmetica
        % winner_windows = filter_rectangles(rectbox, []);
    end

    if detection_with_memory
        % TODO remove
        old_humans = humans;
        humans = winner_windows;
        first_iteration = false;
    end

    destroyrectangles(f1, rectangles);
    figure(f1);
    im1.CData = frame;
    title(strcat('Frame: ', num2str(i)));
    truesize(f1);

    rectangles = drawrectangles(f1, winner_windows, 'y');
    drawnow;
    toc;
end
