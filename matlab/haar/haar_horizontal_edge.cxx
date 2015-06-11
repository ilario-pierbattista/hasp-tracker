#include <iostream>
#include <math.h>
#include "mex.h"
#include "matrix.h"
#include "Image.h"
#include "Rectangle.h"
#include "Haar.h"

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
    if (nrhs != 3) {
        mexErrMsgTxt("I parametri richiesti sono:\n"
                             "\t1)Immagine integrale"
                             "\t2)Punto in alto a sinistra"
                             "\t3)Dimensioni");
    }
    if (nlhs != 1) {
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
    int right, left, m;

    /* Creazione del valore di output */
    plhs[0] = mxCreateDoubleScalar(0);
    double *value = mxGetPr(plhs[0]);

    /* Controllo delle dimensioni dell'immagine */
    if (w % 2 != 0) {
        mexErrMsgTxt("Dimensioni non corrette. La larghezza della "
                             "feature deve essere divisibile per 2\n");
    }
    if (w <= 2 || h <= 1) {
        mexErrMsgTxt("Dimensioni non consentite. La dimensione minima "
                             "della finestra deve essere 4px in larghezza e 2px "
                             "in altezza\n");
    }
    m = w / 2;

    /*
     *     x    x+m-1 x+m     x+w-1       
     *   y +--------++--------+
     *     |        ||        |
     *y+h-1+--------++--------+
     *
     */
    left = *(image + (x + m - 1) * rows + y + h - 1) +
           *(image + x * rows + y) -
           *(image + (x + m - 1) * rows + y) -
           *(image + x * rows + y + h - 1);
    right = *(image + (x + w - 1) * rows + y + h - 1) +
            *(image + (x + m) * rows + y) -
            *(image + (x + m) * rows + y + h - 1) -
            *(image + (x + w - 1) * rows + y);
    *(value) = left - right;

    Image *img = new Image(mxGetPr(prhs[0]), mxGetDimensions(prhs[0]));
    Rectangle *r = new Rectangle(x, y, w, h);
    double haar = Haar::horizontalEdge(img, r);

    if (haar != *value) {
        cout << "Diversi" << endl;
    } else {
        cout << "Uguali" << endl;
    }
    cout << "mex: " << *value << " c++: " << haar << endl;
}
