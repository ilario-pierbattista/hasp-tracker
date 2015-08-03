//
// Created by ilario on 29/06/15.
//

#ifndef HASP_TRACKER_MATLAB_H
#define HASP_TRACKER_MATLAB_H

#include "mex.h"
#include <vector>
#include "feature.h"
#include "adaboost.h"

using namespace std;

/**
 * Controllo delle dimensioni delle matrici in ingresso
 * samples: dimensione della matrice degli esempi
 * labels: dimensione della matrice delle etichette
 * weights: dimensione della matrice dei pesi
 */
void checkSamplesLabelsWeightsDim(const size_t *samples,
                     const size_t *labels,
                     const size_t *weights);

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

/**
 * getStrongClassifier
 * input: dati del classificatore forte
 */
StrongClassifier *getStrongClassifier(const mxArray *input);

#endif //HASP_TRACKER_MATLAB_H
