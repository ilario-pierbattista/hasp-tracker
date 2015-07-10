#include <iostream>
#include <vector>
#include <Sample.h>
#include <Haar.h>
#include <Adaboost.h>
#include <thread>
#include "mex.h"
#include "mapping/matlab.h"

using namespace std;

/*@TODO fattorizzare il codice */

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
    if (nlhs != 1) {
        mexErrMsgTxt("Parametri in output:\n"
                             "\t1)Matrice dei valori\n");
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

    const size_t *size = mxGetDimensions(prhs[3]);
    vector<Haar *> features(size[1]);
    for (unsigned int i = 0; i < size[1]; i++) {
        features.at(i) = getHaarFeature(prhs[3], i);
    }

    plhs[0] = mxCreateNumericMatrix(samples.size(), features.size(), mxSINGLE_CLASS, mxREAL);
    float *values = (float *) mxGetPr(plhs[0]);
    for (unsigned int i = 0; i < samples.size(); i++) {
        for (unsigned int j = 0; j < features.size(); j++) {
            *(values + i * features.size() + j) = (float) features.at(j)->value(samples.at(i));
        }
        cout << i + 1 << "/" << samples.size() << endl;
    }
    cout << endl;

    // Pulizia della memoria
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