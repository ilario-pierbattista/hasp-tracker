function [presence, value] = calculate_strong_classifier(img, strong, threshold, offset, precedentValue, classifierIndex)
    if nargin == 3
        offset = [0 0];
    end

    if nargin == 6 && classifierIndex > 0 && classifierIndex <= length(strong.weakClassifiers)
        % calcola un solo classificatore debole
        t = classifierIndex;
        value = precedentValue + strong.alphas(t) * strong.weakClassifiers(t).classify(img, strong.innerOffset + offset);
        presence = value > threshold * strong.summedAlphaList(t);
    else
        %calcola l'intero classificatore forte
        value = 0;
        for i = [1:length(strong.weakClassifiers)]
            value = value + strong.alphas(i) * strong.weakClassifiers(i).classify(img, strong.innerOffset + offset);
        end
        presence = value > threshold * strong.alphasum;
    end
end
