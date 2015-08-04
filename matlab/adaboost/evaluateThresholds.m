function [accuracy, sensitivity, specificity, mcc] = evaluateThresholds(classifier, frames, labels, thresholds);
    numberOfClassifiers = length(classifier.weakClassifiers);
    % True positives rate
    sensitivity = zeros(length(thresholds), numberOfClassifiers);
    % True negative rate
    specificity = zeros(length(thresholds), numberOfClassifiers);
    % Corrects / Total
    accuracy = zeros(length(thresholds), numberOfClassifiers);
    % Matthews correlation coefficient
    mcc = zeros(length(thresholds), numberOfClassifiers);
    % Conteggio dei positivi e dei negativi
    positivesNum = sum(labels == 1);
    negativesNum = sum(labels == 0);

    % Consultare gli appunti
    WC = weak_classify_samples(classifier, frames);
    AM = [];
    for i = [1:length(classifier.alphas)]
        AM = [AM classifier.alphas];
    end
    WCA = WC * AM;

    fprintf('\n');
    % Per ognuna soglia
    for i = [1:length(thresholds)]
        % Per ogni lunghezza del classificatore forte
        for j = [1:numberOfClassifiers]
            tp = 0; tn = 0;
            fp = 0; fn = 0;
            for k = [1:size(WCA, 1)]
                presence = (WCA(k, j) > thresholds(i) * classifier.summedAlphaList(j));

                if presence && labels(k)
                    tp = tp + 1;
                elseif ~presence && ~labels(k)
                    tn = tn + 1;
                elseif presence && ~labels(k)
                    fp = fp + 1;
                elseif ~presence && labels(k)
                    fn = fn + 1;
                end
            end

            sensitivity(i,j) = tp / positivesNum;
            specificity(i,j) = tn / negativesNum;
            accuracy(i,j) = (tp + tn) / (positivesNum + negativesNum);
            MCC = (tp * tn - fp * fn) ./ sqrt((tp + fp)*(tp + fn)*(tn + fp)*(tn + fn));
            if isnan(MCC)
                MCC = 0;
            end
            mcc(i,j) = MCC;

            percentage = getPercentage(length(thresholds), numberOfClassifiers, i, j);
            fprintf('\r[%.2f%%] THR: %.2f WCN: %4d TPR: %.5f TNR: %.5f ACC: %.5f MCC: %.5f', percentage, thresholds(i), j, sensitivity(i,j), specificity(i,j), accuracy(i,j), mcc(i,j));
        end
    end
end


function percentage = getPercentage(max_i, max_j, i, j);
    total = max_i * max_j;
    current = max_j * (i - 1) + j;
    percentage = round(current * 10000 / total) / 100;
end
