#include <iostream>
#include <vector>
#include <Sample.h>
#include <Haar.h>
#include <Adaboost.h>
#include <thread>
#include "mapping/matlab.h"
#include "mex.h"

#define NUMBER_OF_THREADS 3

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
 * multithreadBestWeakClassifier
 * Calcola il migliore classificatore debole con più di un thread
 *
WeakClassifier *multithreadBestWeakClassifier(
        const mxArray *inputFeatures,
        vector<Sample *> samples,
        unsigned int concurrentThread
);

void bestWeakClassifierForSubset(
        const mxArray *inputFeatures,
        int base,
        int limit,
        vector<Sample *> samples,
        WeakClassifier **pWeakClassifier
); */

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
    if (nrhs < 4 || nrhs > 5) {
        mexErrMsgTxt("I parametri richiesti sono:\n"
                             "\t1)Array delle immagini di allenamento\n"
                             "\t2)Array delle etichette\n"
                             "\t3)Array dei pesi\n"
                             "\t4)Array delle features\n"
                             "\t5)Valori delle features [OPZIONALE]\n");
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
    WeakClassifier *bestWeakClassifier = nullptr;
    float *values = nullptr;

    if (nrhs == 5) {
        values = (float *) mxGetPr(prhs[4]);
    }

    const size_t *size = mxGetDimensions(prhs[3]);
    vector<Haar *> features(size[1]);
    for (unsigned int i = 0; i < size[1]; i++) {
        features.at(i) = getHaarFeature(prhs[3], i);
    }

    if(values != nullptr) {
        bestWeakClassifier = Adaboost::bestWeakClassifier(samples, features, values);
    } else {
        bestWeakClassifier = Adaboost::bestWeakClassifier(samples, features);
    }
    //bestWeakClassifier = multithreadBestWeakClassifier(prhs[3], samples, NUMBER_OF_THREADS);

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


bool checkDimensions(const size_t *samples,
                     const size_t *labels,
                     const size_t *weights) {
    return samples[2] == labels[1] && labels[1] == weights[1];
}


/*
WeakClassifier *multithreadBestWeakClassifier(
        const mxArray *inputFeatures,
        vector<Sample *> samples,
        unsigned int concurrentThread
) {
    const size_t *size = mxGetDimensions(inputFeatures);
    int numberOfFeatures = (int) size[1], featuresPerThread;
    vector<int> base(concurrentThread), limit(concurrentThread);
    vector<WeakClassifier *> classifiers(concurrentThread);
    vector<thread *> threads(concurrentThread);
    WeakClassifier *bestWeakClassifier = nullptr;
    unsigned int i;

    // Divisione dell'input
    featuresPerThread = numberOfFeatures / concurrentThread;
    for (i = 0; i < concurrentThread; i++) {
        base.at(i) = i * featuresPerThread;
        limit.at(i) = (i + 1) * featuresPerThread;
    }
    limit.at(concurrentThread - 1) = numberOfFeatures;

    for (unsigned int j = 0; j < concurrentThread; j++) {
        cout << "Base: " << base.at(j) << " limit: " << limit.at(j) << endl;
    }

    // Creazione dei thread
    for (i = 0; i < concurrentThread; i++) {
        threads.at(i) = new thread(
                bestWeakClassifierForSubset,
                inputFeatures,
                base.at(i),
                limit.at(i),
                samples,
                &(classifiers.at(i))
        );
    }

    // Sincronizzazione dei thread
    for (i = 0; i < concurrentThread; i++) {
        threads.at(i)->join();
    }

    threads.clear();
    base.clear();
    limit.clear();

    // Combinazione dei risultati
    for (i = 0; i < concurrentThread; i++) {
        if (bestWeakClassifier != nullptr) {
            if (classifiers.at(i)->getWeightedError() < bestWeakClassifier->getWeightedError()) {
                delete bestWeakClassifier;
                bestWeakClassifier = classifiers.at(i);
            }
        } else {
            bestWeakClassifier = classifiers.at(i);
        }
    }

    return bestWeakClassifier;
}

void bestWeakClassifierForSubset(
        const mxArray *inputFeatures,
        int base,
        int limit,
        vector<Sample *> samples,
        WeakClassifier **pWeakClassifier
) {
    Haar *feature;
    WeakClassifier *currentWC = nullptr, *bestWC = nullptr;

    for (int i = base; i < limit; i++) {
        feature = getHaarFeature(inputFeatures, i);
        currentWC = Adaboost::bestWeakClassifier(samples, feature);
        if (bestWC != nullptr) {
            if (currentWC->getWeightedError() < bestWC->getWeightedError()) {
                delete bestWC;
                bestWC = currentWC;
            }
        } else {
            bestWC = currentWC;
        }
        delete feature;
    }

    *pWeakClassifier = bestWC;
    cout << "Thread with base: " << base << " limit: " << limit << " finished" << endl;
}*/



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