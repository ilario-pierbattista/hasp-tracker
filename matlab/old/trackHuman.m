clear frames;
clear fm;
% Visualizzazione delle sottocartelle
dir(getenv('REG_HORIZONTAL'))
subfolder = input('Sottocartella da usare: ', 's');

% Caricamento delle path dei frames
frames = getFramesPath(getDatasetPath('REG_HORIZONTAL', subfolder));

% Caricamento dei classificatori
class_folder = input('Cartella dei classificatori: ', 's');
weak_classifiers = dlmread(fullfile(class_folder, 'weakClassifiers.dat'));
alphas = dlmread(fullfile(class_folder, 'alphas.dat'));
classifiers = createStrongClassifier(weak_classifiers, alphas);

im = imagesc(readImageData(char(frames{1}), 512, 424, 16));

% preprocessing delle immagini
fprintf('Preprocessing\n');
tic;
ii = zeros(424, 512, length(frames));
for f = [1:length(frames)]
    ii(:,:,f) = integral_image(floor_rebase(readImageData(char(frames{f}), 512, 424, 16)));
end
toc;

h = zeros(1, length(frames));
for f = [1:length(frames)]
    data = readImageData(char(frames{f}), 512, 424, 16);

    x_size = 160; y_size = 100;

    human = 0; non_human = 0;
    tic;
    for i = [1 : 512 - x_size]
        for j = [1 : 424 - y_size]
            if strongClassify(ii(:,:,i), classifiers, [i-1 j-1])
                human = human + 1;
            else
                non_human = non_human + 1;
            end
        end
    end
    toc;
    fprintf('Frame %d umano: %d non_umano%d\n', f, human, non_human);

    set(im, 'CData', data);
    title(strcat('Frame: ', num2str(f)));
    drawnow;
end
