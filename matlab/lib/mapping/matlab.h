//
// Created by ilario on 29/06/15.
//

#ifndef HASP_TRACKER_MATLAB_H
#define HASP_TRACKER_MATLAB_H

#include "mex.h"
#include <vector>
#include <Sample.h>
#include <Haar.h>

using namespace std;

/**
 * getLabels
 * input: puntatore in input
 */
vector<bool> getLabels(const mxArray *input);

/**
 * getWeights
 * input: puntatore in input
 */
vector<double> getWeights(const mxArray *input);

/**
 * allocateSamples
 * input: dati delle immagini d'allenamento
 * labels: vettore delle etichette
 * weights: vettore dei pesi
 */
vector<Sample *> allocateSamples(const mxArray *input,
                                 vector<bool> labels,
                                 vector<double> weights);

/**
 * getHaarFeature
 * input: dati delle feature
 * index: indice della feature
 */
Haar *getHaarFeature(const mxArray *input, int index);

#endif //HASP_TRACKER_MATLAB_H
