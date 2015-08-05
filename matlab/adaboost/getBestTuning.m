function [threshold, numberOfClassifiers] = getBestTuning(data);
    maximum = max(data.mcc(:));
    [thr, cls] = ind2sub(size(data.mcc), find(ismember(data.mcc, maximum)));
    minClassifiersNumber = min(cls);
    [i,j] = ind2sub(size(cls), find(ismember(cls, minClassifiersNumber)));
    threshold = data.thresholds(thr(i, j));
    numberOfClassifiers = cls(i, j);
end
