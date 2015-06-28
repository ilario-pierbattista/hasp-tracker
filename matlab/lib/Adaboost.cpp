//
// Created by ilario on 11/06/15.
//

#include <list>
#include <math.h>
#include "Adaboost.h"
#include "WeakClassifier.h"

using namespace std;

WeakClassifier *Adaboost::bestWeakClassifier(vector<Sample *> samples, vector<Haar *> features, double *values) {
    FeatureTest *ft;
    list<FeatureTest *> tests;
    list<FeatureTest *>::const_iterator iterator;
    // Somme degli esempi positivi e negativi
    double positiveSum, negativeSum;
    // Somme degli esempi positivi e negativi sotto la soglia
    double partialPositives, partialNegatives;
    // Soglia migliore
    double bestThreshold;
    // Errore minimo assoluto e relativo all'iterazione
    double absoluteMinimumError, currentMinimumError;
    // Errore nella classificazione sotto la soglia e sopra la soglia
    double errorBelowThreshold, errorOverThreshold;
    // Polarità dell'iterazione corrente e dell'iterazione finale
    short currentPolarity, finalPolarity = 1;
    WeakClassifier *bestClassifier = new WeakClassifier();
    unsigned int sampleIndex, featureIndex;

    for (unsigned int i = 0; i < samples.size(); i++) {
        tests.push_back(new FeatureTest());
    }

    for(unsigned int i = 0; i < features.size(); i++) {
        // Inizializzazione
        positiveSum = 0;
        negativeSum = 0;
        partialNegatives = 0;
        partialPositives = 0;
        bestThreshold = 0;
        absoluteMinimumError = INFINITY;
        finalPolarity = 1;

        // Calcolo dei valori della feature per ciascuna immagine
        // Calcolo delle somme dei pesi
        for (iterator = tests.begin(), sampleIndex = 0, featureIndex = 0;
             iterator != tests.end();
             ++iterator, sampleIndex++, featureIndex++) {
            (*iterator)->setFeature(features.at(i));
            (*iterator)->setSample(samples.at(sampleIndex));
            if(values == nullptr) {
                (*iterator)->calculateValue();
            } else {
                (*iterator)->value = *(values + sampleIndex*features.size() + featureIndex);
            }
            if((*iterator)->sample->positive) {
                positiveSum += (*iterator)->sample->weight;
            } else {
                negativeSum += (*iterator)->sample->weight;
            }
        }

        // Ordimento delle immagini in base al valore della feature (crescente)
        tests.sort(FeatureTest::compare);

        // Iterazione sulla lista per estrarre la soglia ad errore minimo
        for (iterator = tests.begin(); iterator != tests.end(); ++iterator) {
            // Aggiornamento delle somme dei pesi delle immagini sotto la soglia
            if ((*iterator)->sample->positive) {
                partialPositives += (*iterator)->sample->weight;
            } else {
                partialNegatives += (*iterator)->sample->weight;
            }

            // Aggiornamento degli errori di classificazione al di sotto e al di sopra
            // della soglia
            errorBelowThreshold = partialNegatives + positiveSum - partialPositives;
            errorOverThreshold = partialPositives + negativeSum - partialNegatives;

            // Calcolo dell'errore relativo all'iterazione corrente
            // minore tra le due classificazioni
            if (errorBelowThreshold < errorOverThreshold) {
                currentMinimumError = errorBelowThreshold;
                currentPolarity = 1;
            } else {
                currentMinimumError = errorOverThreshold;
                currentPolarity = -1;
            }

            if (currentMinimumError < absoluteMinimumError) {
                absoluteMinimumError = currentMinimumError;
                bestThreshold = (*iterator)->value;
                finalPolarity = currentPolarity;
            }
        }

        if(bestClassifier->feature != nullptr) {
            if(bestClassifier->weightedError > absoluteMinimumError) {
                bestClassifier->feature = features.at(i);
                bestClassifier->weightedError = absoluteMinimumError;
                bestClassifier->polarity = finalPolarity;
                bestClassifier->threshold = bestThreshold;
            }
        } else {
            bestClassifier->feature = features.at(i);
            bestClassifier->weightedError = absoluteMinimumError;
            bestClassifier->polarity = finalPolarity;
            bestClassifier->threshold = bestThreshold;
        }
    }

    return bestClassifier;
}


WeakClassifier *Adaboost::bestWeakClassifier(vector<Sample *> samples, vector<Haar *> features) {
    return bestWeakClassifier(samples, features, nullptr);
}

double Adaboost::calculateBetaT(double minimumError, double errorSmothing) {
    return (minimumError + errorSmothing) / (1 - minimumError + errorSmothing);
}

double Adaboost::calculateBetaT(double minimumError) {
    return Adaboost::calculateBetaT(minimumError, 0);
}

double Adaboost::calculateBetaT(WeakClassifier *classifier, vector<Sample *> samples) {
    double errorSmoothing = 1.f / samples.size();
    return Adaboost::calculateBetaT(classifier->getWeightedError(), errorSmoothing);
}

double Adaboost::calculateBetaT(WeakClassifier *classifier) {
    return Adaboost::calculateBetaT(classifier->getWeightedError());
}

vector<double> Adaboost::updateWeights(WeakClassifier *classifier, vector<Sample *> samples) {
    vector<double> updatedWeights(samples.size());
    double betaT = 0, eT = 0;

    betaT = calculateBetaT(classifier, samples);

    for (unsigned int i = 0; i < samples.size(); i++) {
        if (classifier->classify(samples.at(i)) == samples.at(i)->isPositive()) {
            eT = 0;
        } else {
            eT = 1;
        }
        updatedWeights.at(i) = samples.at(i)->getWeight() * pow(betaT, 1 - eT);
    }

    return updatedWeights;
}

/**
 * Implementazioni di FeatureTest
 */
FeatureTest::FeatureTest(Haar *feature, Sample *sample) {
    this->feature = feature;
    this->sample = sample;
    this->calculateValue();
}

void FeatureTest::calculateValue() {
    this->value = this->feature->value(this->sample);
}

bool FeatureTest::compare(FeatureTest *f1, FeatureTest *f2) {
    return f1->value < f2->value;
}

