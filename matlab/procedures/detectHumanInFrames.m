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

for i = indexes
    tic;
    % Lettura e preprocessing del frame
    frame = readImageData(char(framesFiles{i}), width, height, 16);
    processedFrame = preprocessImage(frame,...
        finalClassifier.scaleFactor,...
        finalClassifier.floorValue);

    rectbox = [];
    layers = create_layers(finalClassifier, 150, 150);
    for classifier = transpose(layers);
        rectbox = [rectbox; detect_positive_windows(processedFrame, classifier, 5)];
    end

    rectbox = filter_rectangles(rectbox);

    destroyrectangles(f1, rectangles);
    figure(f1);
    im1.CData = frame;
    title(strcat('Frame: ', num2str(i)));
    truesize(f1);

    rectangles = drawrectangles(f1, rectbox, 'y');
    drawnow;
    toc;
end
