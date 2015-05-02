/* mex_haar_features

  Description:
   This program computes Haar-like features over a given input image (img) in
   order to extract contours. The Haar-like features are used as local derivative
   operators. Particularly, the program computes horizontal (Hx) and vertical (Hy)
   oriented features (Haar-like features) using the integral image (II) of the
   input image (img). This initial pre-processing step is done in advance using a
   mex file (mex_img2II.cc).

  Input:
    prhs[0] <- integral image (II)
        prhs[1] <- Haar filter size

  Output:
    plhs[0] -> Haar filter response (Hx)
    plhs[1] -> Haar filter response (Hy)

  Contact:
    Michael Villamizar
    mvillami@iri.upc.edu
    Institut de Robòtica i Informàtica Industrial CSIC-UPC
    Barcelona - Spain
    2014

*/

#include <stdio.h>
#include <math.h>
#include "mex.h"
#include "matrix.h"

void checkArguments(int nlhs, int nrhs);

// main function
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

    checkArguments(nlhs, nrhs);

    // integral image (II)
    double *II = (double *)mxGetPr(prhs[0]);
    const int *imgSize = (const int *) mxGetDimensions(prhs[0]);

    // Haar filter size
    int hs = (int)mxGetScalar(prhs[1]);

    // image size
    int sy = imgSize[0];
    int sx = imgSize[1];

    // middle point
    int mp = (int)round((double)hs / 2) - 1;

    // output maps limits
    int ly = sy - hs - 1;
    int lx = sx - hs - 1;

    // output feature maps (Hx, Hy)
    int out[2] = {ly, lx};
    plhs[0] = mxCreateNumericArray(2, out, mxDOUBLE_CLASS, mxREAL);
    plhs[1] = mxCreateNumericArray(2, out, mxDOUBLE_CLASS, mxREAL);
    double *HxMap = (double *)mxGetPr(plhs[0]);  // Hx map
    double *HyMap = (double *)mxGetPr(plhs[1]);  // Hy map

    // variables
    int x1, y1, x2, y2;
    double area1, area2, Hx, Hy;

    // sliding window
    for (int x = 0; x < lx; x++) {
        for (int y = 0; y < ly; y++) {

            // region coordinates
            x1 = x;  // left
            y1 = y;  // top
            x2 = x1 + hs - 1;  // right
            y2 = y1 + hs - 1;  // bottom

            // Haar x
            /*
                             hs
                   *********************
                   *         *         *
                   *  left   *  right  *
                   *  area   *  area   * hs
                   *         *         *
                   *********************
            */
            area1 = *(II + x2*sy + y2) +
                *(II + (x1 + mp)*sy + y1) - 
                *(II + x2*sy + y1) - 
                *(II + (x1 + mp)*sy + y2); // right area
            area2 = *(II + (x2 - mp)*sy + y2) +
                *(II + x1*sy + y1) - 
                *(II + (x2 - mp)*sy + y1) - 
                *(II + x1*sy + y2); // left area
            Hx = (area2 - area1) / (hs * hs);

            // Haar y
            /*
                      hs
            *********************
            *      top          *
            *      area         *
            ********************* hs
            *      bottom       *
            *      area         *
            *********************
            */
            area1 = *(II + x2 * sy + (y2 - mp)) + *(II + x1 * sy + y1) - *(II + x2 * sy + y1) - *(II + x1 * sy + (y2 - mp)); // top area
            area2 = *(II + x2 * sy + y2) + *(II + x1 * sy + (y1 + mp)) - *(II + x2 * sy + (y1 + mp)) - *(II + x1 * sy + y2); // bottom area
            Hy = (area2 - area1) / (hs * hs);

            // Haar feature responses
            *(HxMap + x * ly + y) = Hx;
            *(HyMap + x * ly + y) = Hy;

        }
    }
}


void checkArguments(int nlhs, int nrhs) {
    // check
    if (nrhs != 2) {
        mexErrMsgTxt("Two inputs required: 1. input integral image (II) 2. Haar filter size");
    }
    if (nlhs != 2) {
        mexErrMsgTxt("Two outputs required: 1. Haar filter response (Hx) 2. Haar filter response (Hy)");
    }
}

