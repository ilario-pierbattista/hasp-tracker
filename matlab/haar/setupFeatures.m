function features = setupFeatures(samples, scaleFactor, featuresMinimumSizes, featuresStepSizes)
% ${2/.*/U/} Imposta le combinazioni possibili di features
%    ${1/.*/U/} = ${2/.*/U/}()
%
% Imposta le combinazioni possibili di features all'interno dell'area di
% visualizzazione, tenendo conto della dimensione minima di ciascun tipo di
% feature e del passo di incremento della dimensione della stessa.
width = samples(1).width;
height = samples(1).height;
if scaleFactor > 1
    width = round(width / scaleFactor);
    height = round(height / scaleFactor);
end
features = transpose(get_features([width height], featuresMinimumSizes, featuresStepSizes));
