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

bestThreshold = 0;
minimumErrors = length(samples);
tic;
for threshold = [0 : 0.01 : 1]
    errors = 0;
    for f = [1:length(samples)]
        if strongClassify(frames(:,:,f), classifiers, [0 0], threshold) ~= samples(f).positive
            errors = errors + 1;
        end
    end
    fprintf('Errori %d per la soglia %f\n', errors, threshold);

    if errors < minimumErrors
        bestThreshold = threshold;
        minimumErrors = errors;
    end
end
toc;

fprintf('Soglia migliore %f\n', bestThreshold);