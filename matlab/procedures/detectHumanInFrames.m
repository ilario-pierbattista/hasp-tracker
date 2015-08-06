% Procedura di visualizzazione dei frame registrati con il Kinect
% Inizializzazione dell'ambiente
clear frames;
clear fm;
clear subfolders;
clear width;
clear height;
clear content;
initEnvironment;

% Inserimento della path
framesPath = input('Percorso (o variabile globale che contiene la path) dei frames: ', 's');
[framesPath, isdirectory] = checkpath(framesPath);
if isempty(framesPath) || ~isdirectory
    error('La path dei frames non è valida');
end

% Scelta della sottocartella (se presente) con i frames
content = dir(framesPath);
subfolders = [];
% Lettura del contenuto della directory
for i = [1:length(content)]
    if content(i).isdir && ~(strcmp(content(i).name, '.') || strcmp(content(i).name, '..'))
        subfolders = [subfolders; {content(i).name}];
    end
end

if ~isempty(subfolders)
    % Visualizzazione del contentuto della directory
    fprintf('Contenuto della directory:\n');
    for i = [1:length(subfolders)]
        fprintf('%s ', subfolders{i});
    end
    fprintf('\n');

    subf = input('Sottocartella da utilizzare: ', 's');
    framesPath = fullfile(framesPath, subf);
    % Ulteriore controllo della path
    if exist(framesPath) ~= 7
        error('framesPath non valida\n');
    end
end

% Inserimento della dimensione dei frames
width = input('Larghezza [512]: ');
height = input('Altezza [424]: ');
if isempty(width)
    width = 512;
end
if isempty(height)
    height = 424;
end

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
figure;
im1 = imagesc();
for i = [1:length(framesFiles)]
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
