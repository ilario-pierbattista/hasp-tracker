function [tp, tn, fp, fn] = adaboostTesting(finalClassifier, frames, labels);
    tp = 0; tn = 0; fp = 0; fn = 0;

    for i = [1:length(labels)]
        presence = calculate_final_classifier(finalClassifier, frames(:,:,i), [0,0]);

        if presence && labels(i)
            tp = tp + 1;
        elseif presence && ~labels(i)
            fp = fp + 1;
        elseif ~presence && ~labels(i)
            tn = tn + 1;
        elseif ~presence && labels(i)
            fn = fn + 1;
        end

        fprintf(' Frame %d\r', i);
    end
    fprintf('\n');
end
