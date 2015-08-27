#include <iostream>
#include <vector>
#include "mexutils.h"

using namespace std;

void checkinput(int inc, int outc);

/**
 * Main function
 */
void mexFunction(int outc, mxArray *output[], int inc, const mxArray *input[]) {
    StrongClassifier *strong;
    Image *image;
    Point *offset;
    bool presence;

    checkinput(inc, outc);

    strong = getStrongClassifier(input[0]);
    image = readImage(input[1]);
    offset = getPoint(input[2]);

    presence = strong->classify(image, offset);
    output[0] = mxCreateLogicalScalar(presence);

    delete image;
    delete offset;
    delete strong;
}

void checkinput(int inc, int outc) {
    if (inc != 3) {
        mexErrMsgTxt("I parametri richiesti sono:\n"
                             "\t1) Strong classifier\n"
                             "\t2) Immagine\n"
                             "\t3) Offset\n");
    }
    if (outc != 1) {
        mexErrMsgTxt("Output:\n"
                             "\t1) Classe dell'oggetto\n");
    }
}