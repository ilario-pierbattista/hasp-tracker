//
// Created by ilario on 04/08/15.
//

#ifndef HASP_TRACKER_TEMPLATES_DEFINITION_H
#define HASP_TRACKER_TEMPLATES_DEFINITION_H

#include <iostream>
#include <vector>
#include "mex.h"
#include "io.h"

/**
 * getVector
 * input: puntatore all'area di memoria del vettore
 *
 * L'implementazione delle funzioni template deve essere
 * sempre a disposizione del compilatore, ovvero deve
 * rimanere nel header.
 */
template<typename T>
vector<T> getVector(const mxArray *input) {
    vector<T> result(mxGetNumberOfElements(input));
    const size_t *size = mxGetDimensions(input);
    size_t length = 0;

    if (size[0] == 1) {
        length = size[1];
    } else if (size[1] == 1) {
        length = size[0];
    }

    for (unsigned int i = 0; i < length; i++) {
        result.at(i) = (T) mxGetPr(input)[i];
    }
    return result;
}
#endif //HASP_TRACKER_TEMPLATES_DEFINITION_H
