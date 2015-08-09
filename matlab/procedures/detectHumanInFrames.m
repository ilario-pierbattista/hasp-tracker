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
framestep = inputdef('Intervallo con cui analizzare i frame [%d]: ', 20);

% Estrazione delle path di tutti i frames
framesFiles = getFramesPath(framesPath);

% Input della path del classificatore
classifierPath = input('Path del classificatore forte: ', 's');
% Decodifica del classificatore finale
finalClassifier = decodeFinalClassifier(classifierPath);
windowHeight = finalClassifier.windowSize.height / finalClassifier.scaleFactor;
windowWidth = finalClassifier.windowSize.width / finalClassifier.scaleFactor;


% Lettura e preprocessing dei file
rectangles = [];
integralRectangles = [];
f1 = figure;
im1 = imagesc();
f2 = figure;
im2 = imagesc();
for i = [1:framestep:length(framesFiles)]
    tic;
    frame = readImageData(char(framesFiles{i}), width, height, 16);
    processedFrame = preprocessImage(frame,...
        finalClassifier.scaleFactor,...
        finalClassifier.floorValue);
    scaledFrame = scale_image(frame, finalClassifier.scaleFactor);

    [x, y] = detectHuman(processedFrame, finalClassifier, windowWidth, windowHeight);

    destroyrectangles(f1, rectangles);
    destroyrectangles(f2, integralRectangles);

    figure(f1);
    im1.CData = frame;
    title(strcat('Frame: ', num2str(i)));
    truesize(f1);

    figure(f2);
    im2.CData = scaledFrame;
    title(strcat('Frame: ', num2str(i)));
    truesize(f2);

    rectbox = [x y repmat(windowWidth, length(x), 1) repmat(windowHeight, length(x), 1)];
    integralRectangles = drawrectangles(f2, rectbox, 'k');

    rectbox = rectbox * finalClassifier.scaleFactor;
    rectangles = drawrectangles(f1, rectbox, 'y');
    drawnow;
    toc;
end
