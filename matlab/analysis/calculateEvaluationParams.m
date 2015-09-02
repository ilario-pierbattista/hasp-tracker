function [sensitivity, specificity, accuracy, mcc] = calculateEvaluationParams(tp, tn, fp, fn);
    p = tp + fn;
    n = tn + fp;

    sensitivity = tp / p;
    specificity = tn / n;
    accuracy = (tp + tn) / (tp + tn + fp + fn);
    mcc = (tp * tn - fp * fn) ./ sqrt((tp + fp)*(tp + fn)*(tn + fp)*(tn + fn));
end
