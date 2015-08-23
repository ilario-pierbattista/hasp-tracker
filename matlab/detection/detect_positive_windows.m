function windows = detect_positive_windows(frame, finalClassifier);
    x = []; y = [];
    windows = [];
    [frameHeight, frameWidth] = size(frame);
    windowWidth = finalClassifier.samplesSize(1);
    windowHeight = finalClassifier.samplesSize(2);

    for i = [0:frameWidth - windowWidth - 1]
        for j = [0:frameHeight - windowHeight - 1]
            presence = calculate_final_classifier(finalClassifier, frame, [i j]);
            fprintf('Offset x:%3d y:%3d Presenza: %d\r', i, j, presence)
            if presence
                windows = [windows; [i, j, finalClassifier.samplesSize]];
            end
        end
    end
end
