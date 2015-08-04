//
// Created by ilario on 02/08/15.
//

#include "mexutils.h"

/**
 * Controllo degli argomenti
 *
 * @TODO Incompleto e buggato
 */
void checkArgs(int nin, int outn);

void mexFunction(int outn, mxArray *output[], int nin, const mxArray *input[]) {
    StrongClassifier *strong;
    vector<Sample *> samples;
    vector<bool> labels;
    vector<double> thresholds;
    int tp, tn, fp, fn;
    bool presence;

    /* Lettura dell'input */
    checkArgs(nin, outn);
    strong = getStrongClassifier(input[0]);
    labels = getLabels(input[2]);
    samples = allocateSamples(input[1], labels);
    thresholds = getVector<double>(input[3]);

    /* Classificazione di ogni immagine
     * con ogni classificatore debole
     */
    int weakClassification[samples.size()][strong->classifiers.size()];
    for (unsigned int i = 0; i < samples.size(); i++) {
        for (unsigned int j = 0; j < strong->classifiers.size(); j++) {
            Point offset = strong->innerOffset;
            presence = strong->classifiers.at(j)
                    ->classifier->classify(
                            samples.at(i),
                            offset
                    );
            weakClassification[i][j] = presence ? 1 : 0;
        }
    }

    cout << thresholds.size() << " " << strong->classifiers.size() << endl;
    double strongClassificationValue[thresholds.size()][strong->classifiers.size()];
    for(unsigned int i = 0; i < samples.size(); i++) {
        for(unsigned int t = 0; t < strong->classifiers.size(); t++) {
            double classificationValue = 0;
            for(unsigned int j = 0; j <= t; j++) {
                classificationValue += (weakClassification[i][t] *
                                       strong->classifiers.at(t)->alpha);
            }
            cout << i << " " << t << endl;
            strongClassificationValue[i][t] = classificationValue;
            cout << classificationValue << endl;
        }
    }
}

void checkArgs(int nin, int outn) {
    if (nin != 4) {
        mexErrMsgTxt("Input necessario:\n"
                             "\t1) Struttura del classificatore forte\n"
                             "\t2) Frames\n"
                             "\t3) Labels\n"
                             "\t4) Soglie da testare\n");
    }

    if (outn != 4) {
        mexErrMsgTxt("Output necessario:\n"
                             "\t1) True positive matrix\n"
                             "\t2) True negative matrix\n"
                             "\t3) False positive matrix\n"
                             "\t4) False negative matrix\n");
    }
}
