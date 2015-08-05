function plotThresholdEval(data);
    fields = fieldnames(data);
    for i = [1:length(fields)]
        if ~strcmp(fields{i}, 'thresholds')
            figure;
            title(fields{i});
            xlabel('1 <= t <= T (numero di classificatori deboli)');
            ylabel('threshold');
            zlabel(fields{i});
            shading interp;
            Y = data.thresholds;
            Z = getfield(data, fields{i});
            X = [1:size(Z, 2)];
            surface(X, Y, Z);
            rotate3d on;
        end
    end
end
