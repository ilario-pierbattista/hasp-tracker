function presence = calculate_final_classifier(final, frame, offset);
    classifiers = {'x', 'y', 'o1', 'o2'};
    % classifiers = {'x', 'y'};
    presence = false;
    for i = [1:length(classifiers)]
        presence = calculate_strong_classifier(getfield(final, classifiers{i}), frame, offset);
        if presence
            break;
        end
    end
end
