function presence = calculate_final_classifier(final, frame, offset);
    global CLASSIFIER_NAMES;

    presence = false;
    for classifier = CLASSIFIER_NAMES
        classifier = char(classifier);
        % Utilizza la funzione matlab
        presence = calculate_strong_classifier(getfield(final, classifier), frame, offset);
        % Utilizza la funzione in C++
        % @TODO ha un utilizzo anomalo di memoria, correggerlo
        % presence = strong_classify(getfield(final, classifier), frame, offset);
        if presence
            break;
        end
    end
end
