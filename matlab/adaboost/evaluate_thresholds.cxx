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

    checkArgs(nin, outn);
    strong = getStrongClassifier(input[0]);
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
