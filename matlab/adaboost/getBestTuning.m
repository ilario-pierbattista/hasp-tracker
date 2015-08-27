function [threshold, numberOfClassifiers] = getBestTuning(data, param);
    % getBestTuning Ricerca il tuning migliore per l'algoritmo.
    % Esempio:
    %   [t, c] = getBestTuning(data) restituisce la coppia di valori che massimizza il Matthews Correlation Coefficient.
    %   [t, c] = getBestTuning(data, 'accuracy') restituisce la coppia di valori che massimizza l'accuracy.

    if nargin == 1
        param = 'mcc';
    end

    paramEval = getfield(data, param);
    minimum_number_of_classifier = 0;

    paramEval = paramEval(:,minimum_number_of_classifier + 1:size(paramEval, 2));

    maximum = max(paramEval(:));
    [thr, cls] = ind2sub(size(paramEval), find(ismember(paramEval, maximum)));
    % minClassifiersNumber = min(cls);
    % minThreshold = min(thr);
    maxClassifierNumber = max(cls);
    % Selezione del numero di classificatori più basso
    % [i,j] = ind2sub(size(cls), find(ismember(cls, minClassifiersNumber)));
    % Selezione della soglia più bassa
    % [i,j] = ind2sub(size(thr), find(ismember(thr, minThreshold)));
    % Selezione del numero di classificatori forti più alto
    [i,j] = ind2sub(size(cls), find(ismember(cls, maxClassifierNumber)));
    % Nel caso in cui i e j siano vettori
    i = min(i); j = min(j);
    threshold = data.thresholds(thr(i, j));
    numberOfClassifiers = minimum_number_of_classifier + cls(i, j);
end
