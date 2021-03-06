function encodeWeakClassifier(dataPath,...
    weakClassifiers,...
    weightedErrors,...
    weightDistributions,...
    betaFactors,...
    alphaFactors,...
    scaleFactor,...
    trainingSamplesSize,...
    floorValue);

    [folder, isdirectory] = checkpath(dataPath);
    if isempty(folder) || ~isdirectory
        error('Path non valida');
    end

    dlmwrite(fullfile(folder, 'weakClassifiers.dat'), weakClassifiers,...
    'precision', '%.10f');
    dlmwrite(fullfile(folder, 'weightedErrors.dat'), weightedErrors,...
    'precision', '%.10f');
    dlmwrite(fullfile(folder, 'weights.dat'), weightDistributions,...
    'precision', '%.10f');
    dlmwrite(fullfile(folder, 'betasT.dat'), betaFactors,...
    'precision', '%.10f');
    dlmwrite(fullfile(folder, 'alphas.dat'), alphaFactors,...
    'precision', '%.10f');
    dlmwrite(fullfile(folder, 'scaleFactor.dat'), scaleFactor,...
    'precision', '%.10f');
    dlmwrite(fullfile(folder, 'samplesSize.dat'), trainingSamplesSize,...
    'precision', '%.10f');
    dlmwrite(fullfile(folder, 'floorValue.dat'), floorValue,...
    'precision', '%.10f');
end
