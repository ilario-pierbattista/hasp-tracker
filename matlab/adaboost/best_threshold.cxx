#include <stdio.h>
#include <math.h>
#include "mex.h"
#include "matrix.h"

typedef short int int16;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    /* Controllo dell'input */
    if(nrhs != 3) {
        mexErrMsgTxt("I parametri richiesti sono:\n"
                "\t1)Dimensione della finestra"
                "\t2)Matrice delle dimensioni minime delle feature"
                "\t3)Matrice degli incrementi di ogni feature");
    }
    if(nlhs != 1) {
        mexErrMsgTxt("È richiesto un solo parametro in output:\n"
                "\t1)Array di feature");
    }
}