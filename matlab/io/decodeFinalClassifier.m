function finalClassifier = decodeFinalClassifier(dataPath, windowSize);
    [dataPath, isdirectory] = checkpath(dataPath);
    if isempty(dataPath) || ~isdirectory
        error('Path del classificatore finale non valida');
    end

    % Deserializzazione dei classificatori forti presenti
    [folderx, isdirectoryx] = checkpath(fullfile(dataPath, 'x'));
    [foldery, isdirectoryy] = checkpath(fullfile(dataPath, 'y'));
    [foldero1, isdirectoryo1] = checkpath(fullfile(dataPath, 'o1'));
    [foldero2, isdirectoryo2] = checkpath(fullfile(dataPath, 'o2'));
    finalClassifier = struct();
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
end
