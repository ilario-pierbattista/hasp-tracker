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

% Estrazione delle path di tutti i frames
framesFiles = getFramesPath(framesPath);

% Input della path del classificatore
classifierPath = input('Path del classificatore forte: ', 's');
% Decodifica del classificatore finale
finalClassifier = decodeFinalClassifier(classifierPath);
windowHeight = finalClassifier.windowSize.height / finalClassifier.scaleFactor;
windowWidth = finalClassifier.windowSize.width / finalClassifier.scaleFactor;

framestep = inputdef('Intervallo con cui analizzare i frame [%d]: ', 20);

% Lettura e preprocessing dei file
rectangles = [];
figure;
im1 = imagesc();
for i = [1:frameStep:length(framesFiles)]
    tic;
    frame = readImageData(char(framesFiles{i}), width, height, 16);
    processedFrame = preprocessImage(frame,...
        finalClassifier.scaleFactor,...
        finalClassifier.floorValue);
    [x, y] = detectHuman(processedFrame, finalClassifier, windowWidth, windowHeight);
    for j = [1:length(rectangles)]
        delete(rectangles(j));
    end
    rectangles = [];
    im1.CData = frame;
    title(strcat('Frame: ', num2str(i)));
    for j = [1:length(x)]
        % Ritorno alle dimensioni normali
        rectbox = [x(j) y(j) windowWidth windowHeight] * finalClassifier.scaleFactor;
        r = rectangle('Position', rectbox, 'EdgeColor', 'y');
        rectangles = [rectangles; r];
    end
    drawnow;
    toc;
end
