%% createStrongClassifier: A partire da un insieme di classificatori deboli,
%% con relativi fattori moltiplicativi, crea un classificatore forte
function classifier = createStrongClassifier(weakClassifiers, alphas)
	classifier = [weakClassifiers alphas];
