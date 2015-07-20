#include <stdio.h>
#include <math.h>
#include "mex.h"
#include "Image.h"

/*
 * Main function
 *
 * nlhs:    Numero atteso di output
 * plhs:    Array di puntatori all'output
 * nrhs:    Numero di parametri in input
 * prhs:    Array di puntatori all'input
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    /* Controllo dell'input */
    if (nrhs != 1) {
        mexErrMsgTxt("È richiesto un solo parametro in input:\n"
                             "\t1)Immagine");
    }
    if (nlhs != 1) {
        mexErrMsgTxt("È richiesto un solo parametro in output:\n"
                             "\t1)Immagine processata");
    }

    /* Creazione dell'immagine di output
     * 2 -> array bidimensionale
     * size -> dimensioni
     * mxDOUBLE_CLASS -> tipo di dato
     * mxREAL -> no numeri complessi
     */
    plhs[0] = mxCreateNumericArray(2, mxGetDimensions(prhs[0]),
                                   mxDOUBLE_CLASS, mxREAL);

    Image *origin = new Image(mxGetPr(prhs[0]), mxGetDimensions(prhs[0]));

    Image *destination = new Image();
    destination->setImage(mxGetPr(plhs[0]));
    destination->setSize(mxGetDimensions(plhs[0]));

    Image::floorRebase(origin, destination);
}
