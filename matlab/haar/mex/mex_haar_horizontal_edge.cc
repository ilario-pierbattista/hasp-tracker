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
        mexErrMsgTxt("Sono richiesti 5 parametri di input:\n"
                "\t1)Immagine Integrale"
                "\t2)Coordinata x dell'angolo in alto a sinistra"
                "\t3)Coordinata y dell'angolo in alto a sinistra"
                "\t4)Coordinata x dell'angolo in basso a destra"
                "\t5)Coordinata y dell'angolo in basso a destra");
    }
    if(nlhs != 2) {
        mexErrMsgTxt("È richiesto un solo parametro di output\n"
                "\t1)Valore della feature calcolata");
    }

    /* Lettura dell'immagine in input e delle sue dimensioni */
    double *image = mxGetPr(prhs[0]);
    const int *size = mxGetDimensions(prhs[0]);
    const int rows = size[0];
    const int cols = size[1];
    int x1 = *(int *) mxGetPr(prhs[1]);
    int y1 = *(int *) mxGetPr(prhs[2]);
    int x2 = *(int *) mxGetPr(prhs[3]);
    int y2 = *(int *) mxGetPr(prhs[4]);

    /* Creazione dell'output 
     * 2 -> array bidimensionale 
     * size -> dimensioni 
     * mxDOUBLE_CLASS -> tipo di dato
     * mxREAL -> no numeri complessi
     */
    plhs[0] = mxCreateNumericArray(1, 1, mxDOUBLE_CLASS, mxREAL);
    double *h = mxGetPr(plhs[0]);
    

}
