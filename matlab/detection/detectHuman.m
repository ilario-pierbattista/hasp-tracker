function [x, y] = detectHuman(frame, finalClassifier, windowWidth, windowHeight);
    x = []; y = [];
    [frameHeight, frameWidth] = size(frame);

    for i = [0:frameWidth - windowWidth - 1]
        for j = [0:frameHeight - windowHeight - 1]
            presence = calculate_final_classifier(finalClassifier, frame, [i j]);
            fprintf('Offset x:%3d y:%3d Presenza: %d\r', i, j, presence)
            if presence
                x = [x; i];
                y = [y; j];
            end
        end
    end
end
