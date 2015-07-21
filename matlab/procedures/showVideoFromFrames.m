% Procedura di visualizzazione dei frame registrati con il Kinect
% Inizializzazione dell'ambiente
clear frames;
clear fm;
clear subfolders;
clear subf;
clear width;
clear height;
clear content;
initEnvironment;

% Inserimento della path
path = input('Percorso (o variabile globale che contiene la path) dei frames: ', 's');
if ~isempty(getenv(path))
    % Si ripesca la path dalla variabile globale
    path = getenv(path);
end
% Controllo della validità del percorso
% Affinchè la path sia valida, deve puntare ad una directory
if exist(path) ~= 7
    error('Path non valida\n');
end

% Scelta della sottocartella (se presente) con i frames
content = dir(path);
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
    path = fullfile(path, subf);
    % Ulteriore controllo della path
    if exist(path) ~= 7
        error('Path non valida\n');
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
frames = getFramesPath(path);

% Visualizzazione dei frames
im = imagesc(readImageData(char(frames{1}), width, height, 16));
for i = [1:length(frames)]
    data = readImageData(char(frames{i}), width, height, 16);
    set(im, 'CData', data);
    title(strcat('Frame: ', num2str(i)));
    drawnow;
end
