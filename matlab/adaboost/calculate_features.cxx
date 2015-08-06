#include <iostream>
#include <vector>
#include "mexutils.h"

using namespace std;

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

    checkSamplesLabelsWeightsDim(mxGetDimensions(prhs[0]),
                         mxGetDimensions(prhs[1]),
                         mxGetDimensions(prhs[2]));

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