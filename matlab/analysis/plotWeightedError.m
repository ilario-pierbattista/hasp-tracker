% Pulizia dell'ambiente
clear we;

% Input della path
pathname = input('Path con i dati: ', 's');
% Se la path immessa, non esiste, potrebbe essere un percorso relativo
if ~exist(path)
    path = fullfile(pwd, pathname);
else
    path = pathname;
end
% Controllo dell'esistenza della cartella
if ~exist(path) || ~isdir(path)
    error('Path non valida\n');
end

we = dlmread(fullfile(path, 'weightedErrors.dat'));
x = [1:length(we)];
figure;
plot(x, we);
title(strrep(pathname, '_', '\_'));
xlabel('0 <= t <= T');
ylabel('Weighted error');
