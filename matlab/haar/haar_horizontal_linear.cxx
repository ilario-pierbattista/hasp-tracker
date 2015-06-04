#include <stdio.h>
#include <math.h>
#include "mex.h"
#include "matrix.h"

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
    if(nrhs != 3) {
        mexErrMsgTxt("I parametri richiesti sono:\n"
                "\t1)Immagine integrale"
                "\t2)Punto in alto a sinistra"
                "\t3)Dimensioni");
    }
    if(nlhs != 1) {
        mexErrMsgTxt("È richiesto un solo parametro in output:\n"
                "\t1)Valore della feature");
    }

    /* Lettura dell'immagine in input e delle sue dimensioni */
    double *image = mxGetPr(prhs[0]);
    const int *size = (const int *) mxGetDimensions(prhs[0]);
    const int rows = size[0];
    double *point = mxGetPr(prhs[1]);
    double *fsize = mxGetPr(prhs[2]);
    int x = (int) point[0];
    int y = (int) point[1];
    int w = (int) fsize[0];
    int h = (int) fsize[1];
    int top, center, bottom, m1, m2;

    /* Creazione del valore di output */
    plhs[0] = mxCreateDoubleScalar(0);
    double *value = mxGetPr(plhs[0]);

    /* Controllo delle dimensioni dell'immagine */
    if(h % 4 != 0) {
        mexErrMsgTxt("Dimensioni non corrette. L'altezza della " 
                "feature deve essere divisibile per 4\n");
    }
    if(h <= 4 || w <= 2) {
        mexErrMsgTxt("Dimensioni non consentite: la finestra deve essere "
                "larga almeno 2px ed alta almeno 8px");
    }
    m1 = h / 4;
    m2 = m1 * 3;

    /*
     *       x             x+w-1       
     *     y +----------------+
     *       |                |
     * y+m1-1+----------------+
     * y+m1  +----------------+
     *       |                |
     * y+m2-1+----------------+
     * y+m2  +----------------+
     *       |                |
     *y+h-1  +----------------+
     *
     */
    top = *(image + (x+w-1)*rows + y+m1-1) + 
        *(image + x*rows + y) -
        *(image + (x+w-1)*rows + y) -
        *(image + x*rows + y+m1-1);
    center = *(image + (x+w-1)*rows + y+m2-1) +
        *(image + x*rows + y+m1) -
        *(image + (x+w-1)*rows + y+m1) - 
        *(image + x*rows + y+m2-1);
    bottom = *(image + (x+w-1)*rows + y+h-1) +
        *(image + x*rows + y+m2) -
        *(image + (x+w-1)*rows + y+m2) -
        *(image + x*rows + y+h-1);
    *(value) = top + bottom - center;
}
