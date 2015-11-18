function windows = detect_positive_windows(frame, finalClassifier, positions);
    % Scorrimento della detection window in tutte le possibili posizioni accettate
    % alla ricerca delle finestre positive
    windows = [];
    for i = [1:size(positions, 1)]
        presence = calculate_final_classifier(finalClassifier, frame, positions(i,:));
        % fprintf('Offset x:%3d y:%3d Presenza: %d\r', p(1), p(2), presence)
        if presence
            windows = [windows; [positions(i,:) finalClassifier.samplesSize]];
        end
    end
end
