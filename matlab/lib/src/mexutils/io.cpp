//
// Created by ilario on 29/06/15.
//

#include "io.h"
#include "structure_mapping.h"

using namespace std;

void checkSamplesLabelsWeightsDim(const size_t *samples,
                                  const size_t *labels,
                                  const size_t *weights) {
    bool correct = samples[2] == labels[1] && labels[1] == weights[1];
    if (!correct) {
        mexErrMsgTxt("Le dimensioni dell'array di immagini, "
                             "delle etichette e dei pesi non corrispondono");
    }
}

vector<bool> getLabels(const mxArray *input) {
    double *cursor = mxGetPr(input);
    const size_t *size = mxGetDimensions(input);
    vector<bool> labels(size[1]);
    for (unsigned int i = 0; i < size[1]; i++) {
        labels.at(i) = *(cursor + i) > 0;
    }
    return labels;
}

vector<double> getWeights(const mxArray *input) {
    double *cursor = mxGetPr(input);
    const size_t *size = mxGetDimensions(input);
    vector<double> weights(size[1]);
    for (unsigned int i = 0; i < size[1]; i++) {
        weights.at(i) = *(cursor + i);
    }
    return weights;
}

vector<Sample *> allocateSamples(const mxArray *input,
                                 vector<bool> labels,
                                 vector<double> weights) {
    const size_t *size = mxGetDimensions(input);
    double *data = mxGetPr(input);
    unsigned int samplesCount = (unsigned int) size[2];
    unsigned int lenght = (unsigned int) (size[0] * size[1]);
    vector<Sample *> samples(samplesCount);
    Sample *sample;
    for (unsigned int i = 0; i < samplesCount; i++) {
        sample = new Sample(data + i * lenght,
                            size,
                            labels.at(i),
                            weights.at(i));
        samples.at(i) = sample;
    }
    samples.shrink_to_fit();
    return samples;
}

vector<Sample *> allocateSamples(const mxArray *input, vector<bool> labels) {
    vector<double> weights(0);
    for (unsigned int i = 0; i < labels.size(); i++) {
        weights.push_back(0);
    }
    return allocateSamples(input, labels, weights);
}

vector<Image *> allocateImages(const mxArray *input) {
    const size_t *size = mxGetDimensions(input);
    double *data = mxGetPr(input);
    unsigned int imagesCount = (unsigned int) size[2];
    unsigned int lenght = (unsigned int) (size[0] * size[1]);
    vector<Image *> images(imagesCount);
    Image *img;
    for (unsigned int i = 0; i < imagesCount; i++) {
        img = new Image(data + i * lenght,
                            size);
        images.at(i) = img;
    }
    images.shrink_to_fit();
    return images;
}

Haar *getHaarFeature(const mxArray *input, int index) {
    Haar *feature;
    Rectangle *rectangle;
    int16_t *data = (int16_t *) mxGetData(input);
    const size_t *size = mxGetDimensions(input);
    if (index >= 0 && (unsigned int) index < size[1]) {
        data += (size[0] * index);
    }
    rectangle = new Rectangle(
            (int) *data,
            (int) *(data + 1),
            (unsigned int) *(data + 2),
            (unsigned int) *(data + 3));
    feature = new Haar(rectangle, (int) *(data + 4));
    return feature;
}

StrongClassifier *getStrongClassifier(const mxArray *input) {
    StrongClassifier *strongClassifier = new StrongClassifier();
    mxArray *cursor, *wc_struct;
    double alpha_sum = 0, *alphas;
    classifier_struct *wc = nullptr;

    cursor = mxGetField(input, 0, STRONG_CLASSIFIER_SAMPLES_SIZE);
    strongClassifier->samplesSize = Dimensions(
            (unsigned int) mxGetPr(cursor)[0],
            (unsigned int) mxGetPr(cursor)[1]
    );

    cursor = mxGetField(input, 0, STRONG_CLASSIFIER_INNER_OFFSET);
    strongClassifier->innerOffset = Point(
            (int) mxGetPr(cursor)[0],
            (int) mxGetPr(cursor)[1]
    );

    cursor = mxGetField(input, 0, STRONG_CLASSIFIER_SCALE_FACTOR);
    strongClassifier->scaleFactor = (unsigned int) *mxGetPr(cursor);

    cursor = mxGetField(input, 0, STRONG_CLASSIFIER_FLOOR_VALUE);
    strongClassifier->floorValue = *mxGetPr(cursor);

    wc_struct = mxGetField(input, 0, STRONG_CLASSIFIER_WEAK_CLASSIFIERS);
    alphas = mxGetPr(mxGetField(input, 0, STRONG_CLASSIFIER_ALPHAS));
    vector<classifier_struct *> weakClassifiers(mxGetNumberOfElements(wc_struct));
    for (unsigned int i = 0; i < mxGetNumberOfElements(wc_struct); i++) {
        wc = new classifier_struct();
        wc->classifier = getWeakClassifierFromStruct(wc_struct, i);
        wc->alpha = *(alphas + i);
        alpha_sum += wc->alpha;
        wc->alphaSum = alpha_sum;
        weakClassifiers.at(i) = wc;
    }
    strongClassifier->classifiers = weakClassifiers;

    return strongClassifier;
}

WeakClassifier *getWeakClassifierFromStruct(const mxArray *input, mwIndex index) {
    mxArray *cursor;
    short polarity;
    double threshold;
    Haar * feature;
    WeakClassifier *classifier;

    cursor = mxGetField(input, index, WEAK_CLASSIFIER_FEATURE);
    feature = getHaarFeatureFromStruct(cursor);

    cursor = mxGetField(input, index, WEAK_CLASSIFIER_POLARITY);
    polarity = (short) mxGetPr(cursor)[0];

    cursor = mxGetField(input, index, WEAK_CLASSIFIER_THRESHOLD);
    threshold = mxGetPr(cursor)[0];

    classifier = new WeakClassifier(feature, threshold, polarity, 0);
    return classifier;
}

Haar *getHaarFeatureFromStruct(const mxArray *input) {
    mxArray *cursor;
    Rectangle *r;
    Haar *feature;
    int feature_type;

    cursor = mxGetField(input, 0, FEATURE_TLP);
    Point tl(
            (int) mxGetPr(cursor)[0],
            (int) mxGetPr(cursor)[1]
    );

    cursor = mxGetField(input, 0, FEATURE_DIM);
    Dimensions dims(
            (unsigned int) mxGetPr(cursor)[0],
            (unsigned int) mxGetPr(cursor)[1]
    );

    cursor = mxGetField(input, 0, FEATURE_TYPE);
    feature_type = (int) *mxGetPr(cursor);

    r = new Rectangle(tl, dims);
    feature = new Haar(r, feature_type);
    return feature;
}
