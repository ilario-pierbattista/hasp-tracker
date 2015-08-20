#include <iostream>
#include <vector>
#include "adaboost.h"
#include "mexutils.h"

using namespace std;

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
 * Controllo dell'input
 */
void checkinput(int inc, int outc);

/**
 * Main function
 */
void mexFunction(int outc, mxArray *output[], int inc, const mxArray *input[]) {
    checkinput(inc, outc);
    checkSamplesLabelsWeightsDim(mxGetDimensions(input[0]),
                                 mxGetDimensions(input[1]),
                                 mxGetDimensions(input[2]));

    vector<bool> labels = getLabels(input[1]);
    vector<double> weights = getWeights(input[2]);
    vector<Sample *> samples = allocateSamples(input[0], labels, weights);
    WeakClassifier *bestWeakClassifier = nullptr;
    float *values = nullptr;

    if (inc == 5) {
        values = (float *) mxGetPr(input[4]);
    }

    const size_t *size = mxGetDimensions(input[3]);
    vector<Haar *> features(size[1]);
    for (unsigned int i = 0; i < size[1]; i++) {
        features.at(i) = getHaarFeature(input[3], i);
    }

    if (values != nullptr) {
        bestWeakClassifier = Adaboost::bestWeakClassifier(samples, features, values);
    } else {
        bestWeakClassifier = Adaboost::bestWeakClassifier(samples, features);
    }

    // Output
    if (bestWeakClassifier != nullptr) {
        outputWeakClassifier(&output[0], bestWeakClassifier);
        // Output dell'errore pesato
        output[1] = mxCreateDoubleScalar(bestWeakClassifier->getWeightedError());
        // Output dei pesi aggiornati
        outputUpdatedWeights(&output[2], bestWeakClassifier, samples);
        // Output di betaT
        output[3] = mxCreateDoubleScalar(Adaboost::calculateBetaT(bestWeakClassifier));

        if (outc == 5) {
            // L'indice della feature deve essere incrementato di uno per combaciare
            // con lo script matlab
            output[4] = mxCreateDoubleScalar((double) bestWeakClassifier->featureIndex + 1);
        }

        // Pulizia della memoria
        delete bestWeakClassifier;
    }

    // Pulizia della memoria
    /*@TODO Eliminare features*/
    labels.clear();
    weights.clear();
    for (unsigned int i = 0; i < features.size(); i++) {
        delete features.at(i);
    }
    features.clear();
    for (unsigned int i = 0; i < samples.size(); i++) {
        delete samples.at(i);
    }
    samples.clear();
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

void checkinput(int inc, int outc) {
    if (inc < 4 || inc > 5) {
        mexErrMsgTxt("I parametri richiesti sono:\n"
                             "\t1)Array delle immagini di allenamento\n"
                             "\t2)Array delle etichette\n"
                             "\t3)Array dei pesi\n"
                             "\t4)Array delle features\n"
                             "\t5)Valori delle features [OPZIONALE]\n");
    }
    if (outc < 4 || outc > 5) {
        mexErrMsgTxt("Sono richiesti due parametri di output:\n"
                             "\t1)Classificatore debole\n"
                             "\t2)Errore minimo\n"
                             "\t3)Vettore dei nuovi pesi\n"
                             "\t4)BetaT\n"
                             "\t5)Indice della feature selezionata per il classificatore debole\n");
    }
}