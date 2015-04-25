#include <stdio.h>
#include <math.h>
#include <stdbool.h>
#include "mex.h"

void usage();
bool checkDims(const int ix, const int iy, const int hx, const int hy,
        const int x, const int y);
double calculateArea(double *image, const int rows, int x0, int y0, int x1, int y1);

/*
 * Usage: vertical_haar_edge(integral_image, haar_height, haar_width, x, y)
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    double *ii, *result;
    const int *isize;
    int hrows, hcols, x, y;

    if(nrhs != 5 || nlhs != 1) {
        usage();
    }

    ii = mxGetPr(prhs[0]);
    isize = mxGetDimensions(prhs[0]);
    hrows = (int) mxGetScalar(prhs[1]);
    hcols = (int) mxGetScalar(prhs[2]);
    x = (int) mxGetScalar(prhs[3]);
    y = (int) mxGetScalar(prhs[4]);
    /*Inizializza il risultato a zero */
    plhs[0] = mxCreateDoubleScalar(0);
    result = mxGetPr(plhs[0]);

    if (!checkDims(isize[1], isize[0], hcols, hrows, x, y)) {
        mexErrMsgTxt("Le dimensioni fornite non sono adeguate");
    }

    if(hcols % 2 != 0) {
        mexErrMsgTxt("haar_width deve essere pari\n");
    }   
    
    *result = calculateArea(ii, isize[0], x, y, x+(hcols/2), y+hrows) -
        calculateArea(ii, isize[0], x + hcols/2 + 1, y, x + hcols, y + hrows);
}


void usage() {
    mexErrMsgTxt("Utilizzo:\n"
            "h = vertical_haar_edge(integral_image, haar_height, haar_width, x, y)\n");
}


/*
 * Controlla che non ci siano errori nelle dimensioni
 */
bool checkDims(const int ix, const int iy, const int hx, const int hy,
        const int x, const int y) {
    if(x + hx > ix) {
        return false;
    }
    if(y + hy > iy) {
        return false;
    }
    return true;
}


double calculateArea(double *image, const int rows, int x0, int y0, int x1, int y1) {
    double result = 0;
    result = *(image + x0*rows + y0) +
        *(image + x1*rows + y1) -
        *(image + x1*rows + y0) -
        *(image + x0*rows + y1);
    return result;
}
