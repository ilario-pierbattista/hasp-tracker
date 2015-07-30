function weakClassifiers = decodeWeakClassifier(filePath);
    % Decondifica dei classificatori deboli serializzati
    % nei file .dat alla fine di Adaboost

    [realPath, isdirectory] = checkpath(filePath);
    if isempty(realPath) || ~isdirectory
        error('Path del classficatore debole non valida');
    end

    data = dlmread(fullfile(realPath, 'weakClassifiers.dat'));
    [r, c] = size(data);

    % Controlli sulla dimensione dei dati
    if c ~= 7
        error('Dati corrotti');
    end

    % Formato dei dati:
    % c 1-2: punto in alto a sinistra
    % c 3-4: dimensioni della feature
    % c 5: tipo di feature
    % c 6: polarità del classificatore
    % c 7: soglia del classificatore

    weakClassifiers = [];
    for i = [1:r]
        % Punto in alto a sinistra
        topleft = [data(i, 1) data(i, 2)];
        % Dimensioni
        dimension = [data(i, 3) data(i, 4)];
        % Tipo di feature
        featureType = data(i, 5);
        % Polarità
        polarity = data(i, 6);
        % Soglia
        threshold = data(i, 7);
        % Funzione di calcolo della feature
        handler = featureHandler(featureType, topleft, dimension);
        % Struttura descrittiva delle feature
        feature = struct('topleft', topleft,...
        'dimension', dimension,...
        'calculate', handler);
        % Implementazione del classificatore debole
        classifierFunc = @(img, offset) calculate_weak_classifier(img, feature, polarity, threshold, offset);
        % Struttura descrittiva del classificatore debole
        classifier = struct('feature', feature,...
        'polarity', polarity,...
        'threshold', threshold,...
        'classify', classifierFunc);

        weakClassifiers = [weakClassifiers; classifier];
    end
end


function handler = featureHandler(featureType, topleft, dimension);
    switch featureType
    case 0
        handler = @(img, offset) haar_vertical_edge(img, topleft + offset, dimension);
    case 1
        handler = @(img, offset) haar_horizontal_edge(img, topleft + offset, dimension);
    case 2
        handler = @(img, offset) haar_vertical_linear(img, topleft + offset, dimension);
    case 3
        handler = @(img, offset) haar_horizontal_linear(img, topleft + offset, dimension);
    otherwise
        % Questo statement non dovrebbe essere mai raggiunto
        handler = @(img, offset) haar_vertical_edge(img, topleft + offset, dimension);
    end
end
