#include <stdio.h>
#include <math.h>
#include "mex.h"
#include "../../include/haar-like.h"

void checkArguments(int nlhs, int nrhs);
void usage();

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    checkArguments(nlhs, nrhs);
    
    // Immagine integrale
    double *ii = (double *) mxGetPr(prhs[0]);
    const int *size = (const int *) mxGetDimensions(prhs[0]);

    // Punti dei rettangoli
    int *x1, *y1, *x2, *y2;
    x1 = (int *) mxGetData(prhs[1]);
    y1 = (int *) mxGetData(prhs[2]);
    x2 = (int *) mxGetData(prhs[3]);
    y2 = (int *) mxGetData(prhs[4]);

    H_edge h;
    h.positive = createRectangle(x1, y1);
    h.negative = createRectangle(x2, y2);
    h.area = rectangleArea(h.positive) + 
        rectangleArea(h.negative);

    printf("area %d\n", h.area);
}


/* Funzioni di supporto */
void checkArguments(int nlhs, int nrhs) {
    if(nrhs != 5 || nlhs != 1) {
        usage();
    } 
}


void usage() {
    mexErrMsgTxt("value = haar_like(integral_image, x1, y1, x2, y2)\n"
            "x1, y1: matrici 2x2 delle coordinate dei punti del primo blocco\n");
}
