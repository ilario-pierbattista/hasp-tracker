%% strongClassify: classifica
function presence = strongClassify(image, classifiers, offset);
	linearCombination = 0;
	wcs = [];
	wc = 0;
	for i = [1:length(classifiers)]
		alpha = classifiers(i, 8);
		wc = calculateWeakClassifier(image, classifiers(i,:), offset);
		wcs = [wcs wc];
		linearCombination = linearCombination + alpha * wc;
	end
	alphaSum = sum(classifiers(:,8));
	if linearCombination >= (alphaSum*0.90)
		presence = true;
	else
		presence = false;
	end
	wcs

%% calculateWeakClassifier: calcola il classificatore debole
function value = calculateWeakClassifier(image, classifier, offset)
	f = calcHaarFeature(image, classifier, offset);
	thr = classifier(7);
	pol = classifier(6);
	if(pol * f < pol * thr)
		value = 1;
		fprintf('%f * %f < %f * %f --->[%d]\n', pol, f, pol, thr, value);
	else
		value = 0;
		fprintf('%f * %f > %f * %f --->[%d]\n', pol, f, pol, thr, value);
	end


%% calcHaarFeature: calcola il valore della feature di haar
function value = calcHaarFeature(image, feature, offset)
	tl = [feature(1) + offset(1) feature(2) + offset(2)];
	dimensions = [feature(3) feature(4)];
	switch feature(5)
		case 0
			value = haar_vertical_edge(image, tl, dimensions);
		case 1
			value = haar_horizontal_edge(image, tl, dimensions);
		case 2
			value = haar_vertical_linear(image, tl, dimensions);
		case 3
			value = haar_horizontal_linear(image, tl, dimensions);
		otherwise
			value = NaN;
	end