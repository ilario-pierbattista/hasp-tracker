function encodeThresholdEval(destination, data);
    [destination, isdirectory] = checkpath(destination);
    if isempty(destination) || ~isdirectory
        error('Path di destinazione non valida');
    end

    fields = fieldnames(data);
    for i = [1:length(fields)]
        filename = fullfile(destination, strcat(fields{i}, '.dat'));
        dlmwrite(filename, getfield(data, fields{i}), 'precision', '%.10f');
    end
end
