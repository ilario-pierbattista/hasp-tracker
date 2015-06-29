initEnvironment;
fprintf('Questo script sta usando il primo database di allenamento\n');
samples = getTrainingFrames(getenv('DB1'));

% preprocessing delle immagini
frames = zeros(100, 160, length(samples));
for i = [1:length(samples)]
    image = readImageData(samples(i).filepath, samples(i).width, samples(i).height, 16);   
    image = floor_rebase(image);
    image = integral_image(image);
    frames(:,:,i) = image;
end

% Caricamento dei classificatori
class_folder = input('Cartella dei classificatori: ', 's');
weak_classifiers = dlmread(fullfile(class_folder, 'weakClassifiers.dat'));
alphas = dlmread(fullfile(class_folder, 'alphas.dat'));
classifiers = createStrongClassifier(weak_classifiers, alphas);

errors = 0;
tic;
for f = [1:length(samples)]
    if strongClassify(frames(:,:,i), classifiers, [0 0]) ~= samples(f).positive
        errors = errors + 1;
    end
end
toc;

fprintf('Errori %d \n', errors);
