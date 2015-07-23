function [presence, value] = calculate_weak_classifier(img, feature, polarity, threshold);
    value = feature.calculate(img);
    presence = polarity * value < polarity * threshold;
end
