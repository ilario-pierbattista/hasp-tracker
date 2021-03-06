#include <iostream>
#include "mexutils.h"

using namespace std;

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
    double *point = mxGetPr(prhs[1]);
    double *fsize = mxGetPr(prhs[2]);
    int x = (int) point[0];
    int y = (int) point[1];
    int w = (int) fsize[0];
    int h = (int) fsize[1];

    /* Creazione del valore di output */
    plhs[0] = mxCreateDoubleScalar(0);
    double *value = mxGetPr(plhs[0]);

    /* Controllo delle dimensioni dell'immagine */
    if(h % 2 != 0) {
        mexErrMsgTxt("Dimensioni non corrette. l'altezza della " 
                "feature deve essere divisibile per 2\n");
    }
    if(w <= 1 || h <= 2) {
        mexErrMsgTxt("Dimensioni non consentite. La dimensione minima "
                "della finestra deve essere 2px in larghezza e 4px "
                "in altezza\n");
    }

    Image *img = new Image(mxGetPr(prhs[0]), mxGetDimensions(prhs[0]));
    Rectangle *r = new Rectangle(x, y, w, h);
    *value = Haar::verticalEdge(img, r);
}
