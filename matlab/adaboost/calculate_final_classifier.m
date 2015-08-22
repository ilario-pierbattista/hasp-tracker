function presence = calculate_final_classifier(final, frame, offset);
    global CLASSIFIER_NAMES;

    presence = false;
    for classifier = CLASSIFIER_NAMES
        classifier = char(classifier);
        presence = calculate_strong_classifier(getfield(final, classifier), frame, offset);
        if presence
            break;
        end
    end
end
