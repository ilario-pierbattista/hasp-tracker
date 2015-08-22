function [presence, value] = calculate_weak_classifier(img, feature, polarity, threshold, offset);
    if nargin == 4
        offset = [0 0];
    end
    feature
    value = feature.calculate(img, offset);
    presence = polarity * value < polarity * threshold;
end
