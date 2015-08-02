//
// Created by ilario on 29/06/15.
//

#include "io.h"

void checkSamplesLabelsWeightsDim(const size_t *samples,
                     const size_t *labels,
                     const size_t *weights) {
    bool correct = samples[2] == labels[1] && labels[1] == weights[1];
    if(!correct) {
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