#include <stdio.h>
#include <math.h>
#include "mex.h"

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
    /* Controllo dell'input */
    if(nrhs != 1) {
        mexErrMsgTxt("È richiesto un solo parametro in input:\n"
                "\t1)Immagine");
    }
    if(nlhs != 1) {
        mexErrMsgTxt("È richiesto un solo parametro in output:\n"
                "\t1)Immagine processata");
    }

    /* Lettura dell'immagine in input e delle sue dimensioni */
    double *image = mxGetPr(prhs[0]);
    const size_t *size = mxGetDimensions(prhs[0]);
    const int length = size[0] * size[1];
    int floor = 0;
    
    /* Creazione dell'immagine di output 
     * 2 -> array bidimensionale 
     * size -> dimensioni 
     * mxDOUBLE_CLASS -> tipo di dato
     * mxREAL -> no numeri complessi
     */
    plhs[0] = mxCreateNumericArray(2, size, mxDOUBLE_CLASS, mxREAL);
    double *ii = mxGetPr(plhs[0]);
    
    /* Ricerca del punto di massimo */
    for(int i = 0; i < length; i++) {
        if(floor < *(image + i)) {
            floor = *(image + i);
        }
    }

    /* Ridefinizione delle distanze */
    for(int i = 0; i < length; i++) {
        *(ii + i) = floor - *(image + i);
    }
}
