#include <iostream>
#include "mexutils.h"
#include "arrayfire.h"

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
    int n = af::getDeviceCount();
    for(int i = 0; i < n; i++) {
        af::setDevice(i);
        af::info();
    }
}
