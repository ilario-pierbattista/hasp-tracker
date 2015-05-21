#include <stdio.h>
#include <math.h>
#include "mex.h"
#include "matrix.h"

typedef short int int16;

int count_features(int w, int h, int minw, int minh, int stepw, int steph);
void generate_features(int16 *result, int *cursor, int length, int feature,
        int w, int h, int minw, int minh, int stepw, int steph);

/*
 * Main function
 * nlhs:    Numero atteso di output
 * plhs:    Array di puntatori all'output
 * nrhs:    Numero di parametri in input
 * prhs:    Array di puntatori all'input
 */
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

    double *wsize = mxGetPr(prhs[0]);
    double *fmin = mxGetPr(prhs[1]);
    double *fstep = mxGetPr(prhs[2]);
    int count = 0;
    const int DATA_W = 5;

    const int w = wsize[0], h = wsize[1];
    /* Mi serve solamente il numero di features utilizzate */
    const int fnum = *(mxGetDimensions(prhs[1]));
    if(fnum != (const int)*(mxGetDimensions(prhs[2]))) {
        mexErrMsgTxt("La matrice delle dimensioni minime e la matrice "
                "degli incrementi devono avere la stessa dimensione.");
    }   

    for(int i = 0; i < fnum; i++) {
        count += count_features(w, h,
                *(fmin + i), *(fmin + fnum + i),
                *(fstep + i), *(fstep + fnum + i));
    }

    plhs[0] = mxCreateNumericMatrix(count, DATA_W, mxINT16_CLASS, mxREAL);
    int16 *result = (int16*) mxGetPr(plhs[0]);
    int cursor = 0;

    for(int i = 0; i < fnum; i++) {
        generate_features(result, &cursor, count, i,
                w, h,
                *(fmin + i), *(fmin + fnum + i),
                *(fstep + i), *(fstep + fnum + i));
    }
}

/*
 * Conteggia tutte le features
 */
int count_features(int w, int h, int minw, int minh, int stepw, int steph) {
    int count = 0;
    for(int i = minw; i <= w; i += stepw) {
        for(int j = minh; j <= h; j += steph) {
            count += (w - i + 1)*(h - j + 1);
        }
    }
    return count;
}

/*
 * Generazione di tutte le combinazioni di feature
 */
void generate_features(int16 *result, int *cursor, int length, int feature,
        int w, int h, int minw, int minh, int stepw, int steph) {
    for(int i = minw; i <= w; i += stepw) {
        for(int j = minh; j <= h; j += steph) {
            for(int k = 0; k <= w - i; k++) {
                for(int l = 0; l <= h - j; l++) {
                    *(result + *(cursor)) = k;
                    *(result + length + *(cursor)) = l;
                    *(result + length*2 + *(cursor)) = i;
                    *(result + length*3 + *(cursor)) = j;
                    *(result + length*4 + *(cursor)) = feature;
                    *(cursor) += 1;
                }
            }
        }
    }
}
