initEnvironment;
fprintf('Questo script sta usando il primo database di allenamento\n');
samples = getTrainingFrames(getenv('DB1'));

%definizione di costanti nel codice
T = 5;

% Conteggio dei sample negativi e positivi
m = 0; l = 0;
for i = [1:length(samples)]
    if samples(i).positive
        m = m+1;
    else
        l = l+1;
    end
end

% Inizializzazione dei pesi
w = [];
for i = [1: length(samples)]
    if samples(i).positive
        w = [w 1/(2*m)];
    else
        w = [w 1/(2*l)];
    end
end

% dimensioni minime delle features
fmin = [
    12 12;
    12 12;
    12 12;
    12 12
];
% step incremento delle features
fstep = [
    1 2;
    2 1;
    1 4;
    4 1
];

% Calcolo di tutte le combinazioni di features
width = samples(1).width;
height = samples(1).height;
features = get_features([width height], fmin, fstep);

% preprocessing delle immagini
frames = zeros(height, width, length(samples));
for i = [1:length(samples)]
    image = readImageData(samples(i).filepath, samples(i).width, samples(i).height, 16);   
    image = floor_rebase(image);
    image = integral_image(image);
    frames(:,:,i) = image;
end

% Main loop
for t = [1:T]
    % Normalizzazione dei pesi
    w = w / sum(w);

    % Ricerca del classificatore migliore
    for i = [1:length(features)]
        
    end

    % Aggiornamento dei pesi

end
