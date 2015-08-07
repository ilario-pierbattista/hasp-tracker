function [threshold, numberOfClassifiers] = getBestTuning(data, param);
    if nargin == 1
        param = 'mcc';
    end

    paramEval = getfield(data, param);

    maximum = max(paramEval(:));
    [thr, cls] = ind2sub(size(paramEval), find(ismember(paramEval, maximum)));
    minClassifiersNumber = min(cls);
    minThreshold = min(thr);
    % Selezione del numero di classificatori più basso
    % [i,j] = ind2sub(size(cls), find(ismember(cls, minClassifiersNumber)));
    % Selezione della soglia più bassa
    [i,j] = ind2sub(size(thr), find(ismember(thr, minThreshold)));
    threshold = data.thresholds(thr(i, j));
    numberOfClassifiers = cls(i, j);
end
