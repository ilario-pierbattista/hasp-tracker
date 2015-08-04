//
// Created by ilario on 04/08/15.
//

//
// Created by ilario on 02/08/15.
//

#include "mexutils.h"

/**
 * Controllo degli argomenti
 */
void checkArgs(int nin, int outn);

void mexFunction(int outn, mxArray *output[], int nin, const mxArray *input[]) {
    StrongClassifier *strong;
    vector<Image *> images;
    bool presence;

    /* Lettura dell'input */
    checkArgs(nin, outn);
    strong = getStrongClassifier(input[0]);
    images = allocateImages(input[1]);

    /* Classificazione di ogni immagine
     * con ogni classificatore debole
     */
    int weakClassification[images.size()][strong->classifiers.size()];
    for (unsigned int i = 0; i < images.size(); i++) {
        for (unsigned int j = 0; j < strong->classifiers.size(); j++) {
            Point offset = strong->innerOffset;
            presence = strong->classifiers.at(j)
                    ->classifier->classify(
                            images.at(i),
                            offset
                    );
            weakClassification[i][j] = presence ? 1 : 0;
        }
    }

    size_t m = images.size(), n = strong->classifiers.size();
    output[0] = mxCreateDoubleMatrix(m, n, mxREAL);
    double *outMatrix = mxGetPr(output[0]);
    for(unsigned int i = 0; i<m; i++) {
        for(unsigned int j = 0; j < n; j++) {
            *(outMatrix + j * m + i) = (double) weakClassification[i][j];
        }
    }

}

void checkArgs(int nin, int outn) {
    if (nin != 2) {
        mexErrMsgTxt("Input necessario:\n"
                             "\t1) Struttura del classificatore forte\n"
                             "\t2) Frames\n");
    }

    if (outn != 1) {
        mexErrMsgTxt("Output necessario:\n"
                             "\t1) Matrice delle classificazioni\n");
    }
}
