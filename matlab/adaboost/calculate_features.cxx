#include <iostream>
#include <vector>
#include "mexutils.h"

using namespace std;

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

    const size_t *size = mxGetDimensions(input[3]);
    vector<Haar *> features(size[1]);
    for (unsigned int i = 0; i < size[1]; i++) {
        features.at(i) = getHaarFeature(input[3], i);
    }

    output[0] = mxCreateNumericMatrix(samples.size(), features.size(), mxSINGLE_CLASS, mxREAL);
    float *values = (float *) mxGetPr(output[0]);
    for (unsigned int i = 0; i < samples.size(); i++) {
        for (unsigned int j = 0; j < features.size(); j++) {
            *(values + i * features.size() + j) = (float) features.at(j)->calculateValue(samples.at(i));
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

void checkinput(int inc, int outc) {
    if (inc != 4) {
        mexErrMsgTxt("I parametri richiesti sono:\n"
                             "\t1)Array delle immagini di allenamento\n"
                             "\t2)Array delle etichette\n"
                             "\t3)Array dei pesi\n"
                             "\t4)Array delle features\n");
    }
    if (outc != 1) {
        mexErrMsgTxt("Parametri in output:\n"
                             "\t1)Matrice dei valori\n");
    }
}