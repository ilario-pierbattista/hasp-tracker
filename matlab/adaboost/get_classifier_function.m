function func = get_classifier_function(feature, polarity, threshold);
    func = @(img, offset) calculate_weak_classifier(img, feature, polarity, threshold, offset);
end
