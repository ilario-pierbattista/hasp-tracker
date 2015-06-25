#include <iostream>
#include <vector>
#include <Sample.h>
#include <Haar.h>
#include <Adaboost.h>
#include "mex.h"

using namespace std;

/**
 * Controllo delle dimensioni delle matrici in ingresso
 * samples: dimensione della matrice degli esempi
 * labels: dimensione della matrice delle etichette
 * weights: dimensione della matrice dei pesi
 */
bool checkDimensions(const size_t *samples,
                     const size_t *labels,
                     const size_t *weights);

/**
 * getLabels
 * input: puntatore in input
 */
vector<bool> getLabels(const mxArray *input);

/**
 * getWeights
 * input: puntatore in input
 */
vector<double> getWeights(const mxArray *input);

/**
 * allocateSamples
 * input: dati delle immagini d'allenamento
 * labels: vettore delle etichette
 * weights: vettore dei pesi
 */
vector<Sample *> allocateSamples(const mxArray *input,
                                 vector<bool> labels,
                                 vector<double> weights);

/**
 * getHaarFeature
 * input: dati delle feature
 * index: indice della feature
 */
Haar *getHaarFeature(const mxArray *input, int index);

/**
 * outputWeakClassifier
 * Crea i dati di output per il classificatore debole
 */
void outputWeakClassifier(mxArray **output, WeakClassifier *bestWeakClassifier);

/**
 * outputUpdateWeights
 * Crea i dati di output con il valore dei nuovi pesi
 */
void outputUpdatedWeights(mxArray **output,
                          WeakClassifier *bestWeakClassifier,
                          vector<Sample *> samples);

/**
 * Main function
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    if (nrhs != 4) {
        mexErrMsgTxt("I parametri richiesti sono:\n"
                             "\t1)Array delle immagini di allenamento\n"
                             "\t2)Array delle etichette\n"
                             "\t3)Array dei pesi\n"
                             "\t4)Array delle features\n");
    }
    if (nlhs != 4) {
        mexErrMsgTxt("Sono richiesti due parametri di output:\n"
                             "\t1)Classificatore debole\n"
                             "\t2)Errore minimo\n"
                             "\t3)Vettore dei nuovi pesi\n"
                             "\t4)BetaT\n");
    }

    if (!checkDimensions(mxGetDimensions(prhs[0]),
                         mxGetDimensions(prhs[1]),
                         mxGetDimensions(prhs[2]))) {
        mexErrMsgTxt("Le dimensioni dell'array di immagini, "
                             "delle etichette e dei pesi non corrispondono");
    }

    vector<bool> labels = getLabels(prhs[1]);
    vector<double> weights = getWeights(prhs[2]);
    vector<Sample *> samples = allocateSamples(prhs[0], labels, weights);
    Haar *feature;
    WeakClassifier *bestWeakClassifier = nullptr,
            *currentWeakClassifier = nullptr;
    const size_t *size = mxGetDimensions(prhs[3]);

    // For each feature (size[1])
    for (unsigned int i = 0; i < size[1]; i++) {
        feature = getHaarFeature(prhs[3], i);
        currentWeakClassifier = Adaboost::bestWeakClassifier(samples, feature);
        // Aggiornamento del migliore classificatore
        if (bestWeakClassifier != nullptr) {
            if (currentWeakClassifier->getWeightedError() < bestWeakClassifier->getWeightedError()) {
                delete bestWeakClassifier;
                bestWeakClassifier = currentWeakClassifier;
            }
        } else {
            bestWeakClassifier = currentWeakClassifier;
        }

        delete feature;
    }

    // Output
    if (bestWeakClassifier != nullptr) {
        outputWeakClassifier(&plhs[0], bestWeakClassifier);
        // Output dell'errore pesato
        plhs[1] = mxCreateDoubleScalar(bestWeakClassifier->getWeightedError());
        // Output dei pesi aggiornati
        outputUpdatedWeights(&plhs[2], bestWeakClassifier, samples);
        // Output di betaT
        plhs[3] = mxCreateDoubleScalar(Adaboost::calculateBetaT(bestWeakClassifier, samples));

        // Pulizia della memoria
        delete bestWeakClassifier;
    }

    // Pulizia della memoria
    labels.clear();
    weights.clear();
    for (unsigned int i = 0; i < samples.size(); i++) {
        delete samples.at(i);
    }
    samples.clear();
}


bool checkDimensions(const size_t *samples,
                     const size_t *labels,
                     const size_t *weights) {
    return samples[2] == labels[1] && labels[1] == weights[1];
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

void outputWeakClassifier(mxArray **output, WeakClassifier *bestWeakClassifier) {
    /* Classificatore debole
         * Dati da passare:
         * 0. Punto in alto a sinistra della feature
         * 2. Dimensioni della feature
         * 4. Tipo della feature
         * 5. Polarità
         * 6. Threshold
         */
    *output = mxCreateNumericMatrix(1, 7, mxDOUBLE_CLASS, mxREAL);
    double *outputWeakClassifier = mxGetPr(*output);
    outputWeakClassifier[0] = bestWeakClassifier->getFeature()->getArea()->x;
    outputWeakClassifier[1] = bestWeakClassifier->getFeature()->getArea()->y;
    outputWeakClassifier[2] = bestWeakClassifier->getFeature()->getArea()->width;
    outputWeakClassifier[3] = bestWeakClassifier->getFeature()->getArea()->height;
    outputWeakClassifier[4] = bestWeakClassifier->getFeature()->getCode();
    outputWeakClassifier[5] = bestWeakClassifier->getPolarity();
    outputWeakClassifier[6] = bestWeakClassifier->getThreshold();
}

void outputUpdatedWeights(mxArray **output,
                          WeakClassifier *bestWeakClassifier,
                          vector<Sample *> samples) {
    vector<double> weights = Adaboost::updateWeights(bestWeakClassifier, samples);
    *output = mxCreateNumericMatrix(1, samples.size(), mxDOUBLE_CLASS, mxREAL);
    double *newWeighs = mxGetPr(*output);
    for (unsigned int i = 0; i < samples.size(); i++) {
        *(newWeighs + i) = weights.at(i);
    }

    // Pulizia della memoria
    weights.clear();
}