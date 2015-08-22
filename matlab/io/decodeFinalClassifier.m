function finalClassifier = decodeFinalClassifier(dataPath, disableOffset);
    if nargin == 1
        disableOffset = false;
    end

    dataPath = checkisdir(dataPath);
    if dataPath == false
        error('Path del classificatore finale non valida');
    end

    global CLASSIFIER_NAMES;

    % Decodifica di ogni classificatore forte
    finalClassifier = struct();
    for classifier = CLASSIFIER_NAMES
        classifier = char(classifier);
        
        folder = checkisdir(fullfile(dataPath, classifier));
        if folder ~= false
            data = decodeStrongClassifier(folder);
            finalClassifier = setfield(finalClassifier, classifier, data);
            if ~isfield(finalClassifier, 'scaleFactor')
                finalClassifier.scaleFactor = data.scaleFactor;
            end
            if ~isfield(finalClassifier, 'floorValue')
                finalClassifier.floorValue = data.floorValue;
            end
            if ~isfield(finalClassifier, 'samplesSize')
                finalClassifier.samplesSize = data.samplesSize;
            end
        end
    end
    if isempty(fieldnames(finalClassifier))
        error('Errore nella decodifica: dati non presenti.');
    end

%{ Deserializzazione dei classificatori forti presenti
    [folderx, isdirectoryx] = checkpath(fullfile(dataPath, 'x'));
    [foldery, isdirectoryy] = checkpath(fullfile(dataPath, 'y'));
    [foldero1, isdirectoryo1] = checkpath(fullfile(dataPath, 'o1'));
    [foldero2, isdirectoryo2] = checkpath(fullfile(dataPath, 'o2'));
    if ~isempty(folderx) && isdirectoryx
        finalClassifier.x = decodeStrongClassifier(folderx);
        finalClassifier.scaleFactor = finalClassifier.x.scaleFactor;
        finalClassifier.floorValue = finalClassifier.x.floorValue;
    end
    if ~isempty(foldery) && isdirectoryy
        finalClassifier.y = decodeStrongClassifier(foldery);
        finalClassifier.scaleFactor = finalClassifier.y.scaleFactor;
        finalClassifier.floorValue = finalClassifier.y.floorValue;
    end
    if ~isempty(foldero1) && isdirectoryo1
        finalClassifier.o1 = decodeStrongClassifier(foldero1);
        finalClassifier.scaleFactor = finalClassifier.o1.scaleFactor;
        finalClassifier.floorValue = finalClassifier.o1.floorValue;
    end
    if ~isempty(foldero2) && isdirectoryo2
        finalClassifier.o2 = decodeStrongClassifier(foldero2);
        finalClassifier.scaleFactor = finalClassifier.o2.scaleFactor;
        finalClassifier.floorValue = finalClassifier.o2.floorValue;
    end
    if isempty(fieldnames(finalClassifier))
        error('Nessun classificatore trovato');
    end
%}

%{
    if ~disableOffset
        if isfield(finalClassifier, 'o1')
            windowSize = struct('width', finalClassifier.o1.samplesSize(1),...
            'height', finalClassifier.o1.samplesSize(2));
        elseif isfield(finalClassifier, 'o2')
            windowSize = struct('width', finalClassifier.o2.samplesSize(1),...
            'height', finalClassifier.o2.samplesSize(2));
        end

        % Calcolo degli offset dei classificatori ortogonali
        if isfield(finalClassifier, 'x')
            xoffset = finalClassifier.x.samplesSize(1);
            xoffset = (windowSize.width - xoffset) / finalClassifier.scaleFactor;
            finalClassifier.x.innerOffset = [xoffset 0];
        end
        if isfield(finalClassifier, 'y')
            yoffset = finalClassifier.y.samplesSize(2);
            yoffset = (windowSize.height - yoffset) / finalClassifier.scaleFactor;
            finalClassifier.y.innerOffset = [0 yoffset];
        end

        finalClassifier.windowSize = windowSize;
    end
%}
end
