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
                "\t1)Immagine Integrale");
    }

    /* Lettura dell'immagine in input e delle sue dimensioni */
    double *image = mxGetPr(prhs[0]);
    const int *size = mxGetDimensions(prhs[0]);
    const int rows = size[0];
    const int cols = size[1];
    
    /* Creazione dell'immagine di output 
     * 2 -> array bidimensionale 
     * size -> dimensioni 
     * mxDOUBLE_CLASS -> tipo di dato
     * mxREAL -> no numeri complessi
     */
    plhs[0] = mxCreateNumericArray(2, size, mxDOUBLE_CLASS, mxREAL);
    double *ii = mxGetPr(plhs[0]);

    /*
     * Calcolo dell'immagine integrale
     * Inizializzazione dell'angolo (evita di introdurre strutture
     * condizionali all'interno del loop)
     */
    *(ii) = *(image);
    *(ii + cols) = *(image + cols) + *(ii);
    *(ii + 1) = *(image + 1) + *(ii);
    /*
     * *(ii + 1) = ii(2,1) (in matlab)
     * *(ii + rows) = ii(1,2) (in matlab)
     */
    for(int i = 1; i < rows; i++) {
        *(ii + i) = *(image + i) + 
            *(ii + (i-1));
    }
    for(int j = 1; j < cols; j++) {
        *(ii + j*rows) = *(image + j*rows) +
            *(ii + (j-1)*rows);
    }
    for(int i = 1; i < cols; i++) {
        for(int j = 1; j < rows; j++) {
            *(ii + i*rows + j) =            // ii(x,y) = 
                *(image + i*rows + j) +     // img(x,y) + 
                *(ii + (i-1)*rows + j) +    // ii(x-1,y) + 
                *(ii + i*rows + (j-1)) -    // ii(x,y-1) -
                *(ii + (i-1)*rows + (j-1)); // ii(x-1,y-1)
        }
    }
}
