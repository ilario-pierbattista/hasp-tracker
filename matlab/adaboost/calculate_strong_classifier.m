function [presence, value] = calculate_strong_classifier(strong, img, offset);
    if nargin == 3
        offset = [0 0];
    end

    value = 0;
    alphasum = 0;
    %strong.threshold
    %strong.numberOfClassifiers
    for i = [1:length(strong.numberOfClassifiers)]
        value = value + strong.alphas(i) * strong.weakClassifiers(i).classify(img, strong.innerOffset + offset);
        alphasum = alphasum + strong.alphas(i);
    end
    presence = value > strong.threshold * alphasum;
end
