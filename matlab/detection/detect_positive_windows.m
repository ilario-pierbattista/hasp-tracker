function windows = detect_positive_windows(frame, finalClassifier, sliding_step);
    if nargin == 2
        sliding_step = 1;
    end
    x = []; y = [];
    windows = [];
    [frameHeight, frameWidth] = size(frame);
    windowWidth = finalClassifier.samplesSize(1);
    windowHeight = finalClassifier.samplesSize(2);

    for i = [0:sliding_step:frameWidth - windowWidth - 1]
        for j = [0:sliding_step:frameHeight - windowHeight - 1]
            presence = calculate_final_classifier(finalClassifier, frame, [i j]);
            fprintf('Offset x:%3d y:%3d Presenza: %d\r', i, j, presence)
            if presence
                windows = [windows; [i, j, finalClassifier.samplesSize]];
            end
        end
    end
end
