function plotThresholdEval(data);
    fields = fieldnames(data);
    for i = [1:length(fields)]
        figure;
        title(fields{i});
        xlabel('1 <= t <= T (numero di classificatori deboli)');
        ylabel('Valore di soglia (percentuale)');
        zlabel(fields{i});
        shading interp;
        surface(getfield(data, fields{i}));
        rotate3d on;
    end
end
