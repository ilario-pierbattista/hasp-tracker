function layers = create_layers(classifier, min_size, max_size);
    layers = [];
    original_size = classifier.samplesSize(1);
    layers_step_increment = 5;

    % Crescita lineare delle dimensioni.
    % A differenza del rilevamento di volti umani, qui le dimensioni sono molto
    % meno variabili rispetto al campo visivo.
    current_size = min_size;
    while current_size <= max_size;
        scale_factor = current_size / original_size;
        layers = [layers; scale_final_classifier(classifier, scale_factor)];
        current_size = current_size + layers_step_increment;
    end
end
