function [tp, tn, fp, fn] = test_classifier(finalClassifier, frames, labels);
    tp = 0; tn = 0; fp = 0; fn = 0;

    width = size(frames(:,:,1), 1);
    sampleWidth = finalClassifier.samplesSize(1);
    if sampleWidth ~= width
        finalClassifier = scale_final_classifier(finalClassifier, width/sampleWidth);
    end

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
