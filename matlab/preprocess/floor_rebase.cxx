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
    Image *origin, *destination;
    double floorValue;

    /* Controllo dell'input */
    if (nrhs < 1 || nrhs > 2) {
        mexErrMsgTxt("È richiesto un solo parametro in input:\n"
                             "\t1)Immagine\n"
                             "\t2)Floor Value\n");
    }
    if (nlhs != 1) {
        mexErrMsgTxt("È richiesto un solo parametro in output:\n"
                             "\t1)Immagine processata");
    }

    plhs[0] = mxCreateNumericArray(2, mxGetDimensions(prhs[0]),
                                   mxDOUBLE_CLASS, mxREAL);

    origin = new Image(mxGetPr(prhs[0]), mxGetDimensions(prhs[0]));
    destination = new Image();
    destination->setImage(mxGetPr(plhs[0]));
    destination->setSize(mxGetDimensions(plhs[0]));

    if(nrhs == 2) {
        floorValue = *(mxGetPr(prhs[1]));
        Image::floorRebase(origin, destination, floorValue);
    } else if(nrhs == 1) {
        Image::floorRebase(origin, destination);
    }

}
