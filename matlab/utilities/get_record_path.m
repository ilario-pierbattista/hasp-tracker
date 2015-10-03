function record_path = get_record_path(id, classification);
    positives = 'REG';
    negatives = 'FALSE';
    env_name = '';

    if classification
        env_name = strcat(positives, num2str(id));
    else
        env_name = strcat(negatives, num2str(id));
    end
    record_path = checkisdir(env_name);

    % Quando si tratta di registrazioni di falsi, il percorso va bene così com'è
    % Quando si tratta di registrazioni di positivi, bisogna prendere i frames contenuti
    % nella sottocartella "random", da dove vengono ritagliati gli elementi del dataset
    % di testing.
    record_path = checkpath(record_path);
    if classification
        record_path = fullfile(record_path, 'random');
    end
end
