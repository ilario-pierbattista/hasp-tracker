#include <stdio.h>
#include "mexutils.h"

/*
 * Main function
 *
 *
 *
 * nlhs:    Numero atteso di output
 * plhs:    Array di puntatori all'output
 * nrhs:    Numero di parametri in input
 * prhs:    Array di puntatori all'input
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    Image *origin, *destination;
    const size_t *originalDims;
    size_t newSize[2];
    unsigned int scaleFactor;

    /* Controllo dell'input */
    if (nrhs != 2) {
        mexErrMsgTxt("È richiesto un solo parametro in input:\n"
                             "\t1)Immagine\n"
                             "\t2)Scale factor\n");
    }
    if (nlhs != 1) {
        mexErrMsgTxt("È richiesto un solo parametro in output:\n"
                             "\t1)Immagine processata\n");
    }

    scaleFactor = (unsigned int) *(mxGetPr(prhs[1]));
    originalDims = mxGetDimensions(prhs[0]);
    newSize[0] = originalDims[0] / scaleFactor;
    newSize[1] = originalDims[1] / scaleFactor;

    // Allocazione della memoria per le immagini
    plhs[0] = mxCreateNumericArray(2, newSize,
                                   mxDOUBLE_CLASS, mxREAL);

    // Creazione degli oggetti wrapper delle immagini
    origin = new Image(mxGetPr(prhs[0]), mxGetDimensions(prhs[0]));
    destination = new Image();
    destination->setImage(mxGetPr(plhs[0]));
    destination->setSize(mxGetDimensions(plhs[0]));

    Image::scaleImage(origin, destination, scaleFactor);
}
