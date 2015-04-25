#include <stdio.h>
#include <math.h>
#include <stdbool.h>
#include "mex.h"

/*
 * Calcola le edge haar features
 *
 * Esempio di utilizzo:
 * H = mex_haar_edges(integral_image, [height, width], orientation)
 * [Hv, Hh] = mex_haar_edges(integral_image, [height, width])
 * h = mex_haar_edges(integral_image, [height, width], orientation
 *      [x, y])
 * [hx, hy] = mex_haar_edges(integral_image, [height, width], [x, y])
 * 
 * integral_image: immagine integrale
 * orientation: orientazione (
 *  'h' => orizzontale, 
 *  'v' => verticale,
 * )
 * [height, width]: altezza e largezza. La finestra verrà splittata a metà
 *  (devono essere delle quantità pari)
 * [x, y]: posizione (angolo in alto a destra) da cui calcolare la 
 *  feature
 * 
 */

void usage();
double haar_vertical_edge(double *ii, int *size, int *position);
double haar_horizontal_edge(double *ii, int *size, int *position);
bool checkDimensions(int *image_size, int *features_size);
bool checkDimensions(int *image_size, int *features_size, int *position);

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    double *ii;
    const int *isize; // 0: rows  1: cols
    int *fsize, *position;
    char *orientation;

    /*
     * Primo controllo sui parametri di input
     */
    if (nrhs >= 2 && nrhs <= 4) {
        ii = mxGetPr(prhs[0]);
        isize = mxGetDimensions(prhs[0]);
        fsize = (int *) mxGetData(prhs[1]);
        /* 
        *(fsize) = (int) *mxGetPr(prhs[1]);
        *(fsize + 1) = (int) *(mxGetPr(prhs[1]) + 1);
        */
        printf("%d %d\n", *fsize, *(fsize+1));
    } else {
        usage();
    }

    /*
     * Smistamento alla funzione di competenza a seconda dei
     * parametri passati alla funzione
     */
    if(nrhs == 2) {
        if(nlhs == 2) {  // Calcola tutte le features di haar
            
        } else {
            usage();
        } 
    } else if (nrhs == 3) {
        if(nlhs == 1) {
            orientation = (char *)mxGetData(prhs[2]);
        } else if(nlhs == 2) {  // Calcola una feature in un punto specifico
            position = (int *) mxGetData(prhs[2]);
        } else {
            usage();
        }
    } else if (nrhs == 4) {
        if(nlhs == 1) {     // Calcola una feature in un punto con orientazione
            orientation = (char *)mxGetData(prhs[2]);
            position = (int *)mxGetData(prhs[3]);
        } else {
            usage();
        }
    } else {
        usage();
    }
}


bool checkDimensions(int *image_size, int *features_size) {
    return false;
}


bool checkDimensions(int *image_size, int *features_size, int *position) {
    return false;
}


double haar_vertical_edge(double *ii, int *size, int *position) {
    double value = 0;
    return 0;
}

double haar_horizontal_edge(double *ii, int *size, int *position) {
    return 0;
}

void usage() {
    mexErrMsgTxt("* Esempio di utilizzo:\n"
            "H = mex_haar_edges(integral_image, [height, width], orientation)\n"
            "[Hv, Hh] = mex_haar_edges(integral_image, [height, width])\n"
            "h = mex_haar_edges(integral_image, [height, width], orientation, [x, y]) \n"
            "[hx, hy] = mex_haar_edges(integral_image, [height, width], [x, y])\n\n"
            "integral_image: immagine integrale\n"
            "orientation: orientazione (\n"
            "\t'h' => orizzontale,'v' => verticale\n)\n"
            "[height, width]: altezza e largezza. La finestra verrà splittata a metà\n"
            "(devono essere delle quantità pari)\n"
            "[x, y]: posizione (angolo in alto a destra) da cui calcolare la feature");
}
