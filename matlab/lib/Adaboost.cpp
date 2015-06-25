//
// Created by ilario on 11/06/15.
//

#include <list>
#include <math.h>
#include "Adaboost.h"
#include "WeakClassifier.h"

using namespace std;

WeakClassifier *Adaboost::bestWeakClassifier(vector<Sample *> samples, Haar *feature) {
    FeatureTest *ft;
    list<FeatureTest *> tests;
    list<FeatureTest *>::const_iterator iterator;
    // Somme degli esempi positivi e negativi
    double positiveSum = 0, negativeSum = 0;
    // Somme degli esempi positivi e negativi sotto la soglia
    double partialPositives = 0, partialNegatives = 0;
    // Soglia migliore
    double bestThreshold = 0;
    // Errore minimo assoluto e relativo all'iterazione
    double absoluteMinimumError = INFINITY, currentMinimumError;
    // Errore nella classificazione sotto la soglia e sopra la soglia
    double errorBelowThreshold = 0, errorOverThreshold = 0;
    // Polarità dell'iterazione corrente e dell'iterazione finale
    short currentPolarity, finalPolarity = 1;

    // Calcolo dei valori della feature per ciascuna immagine
    // Calcolo delle somme dei pesi
    for (unsigned int i = 0; i < samples.size(); i++) {
        ft = new FeatureTest(feature, samples.at(i));
        if (ft->getSample()->isPositive()) {
            positiveSum += ft->getSample()->getWeight();
        } else {
            negativeSum += ft->getSample()->getWeight();
        }
        tests.push_back(ft);
    }

    // Ordimento delle immagini in base al valore della feature (crescente)
    tests.sort(FeatureTest::compare);

    // Iterazione sulla lista per estrarre la soglia ad errore minimo
    for (iterator = tests.begin(); iterator != tests.end(); ++iterator) {
        // Aggiornamento delle somme dei pesi delle immagini sotto la soglia
        if ((*iterator)->getSample()->isPositive()) {
            partialPositives += (*iterator)->getSample()->getWeight();
        } else {
            partialNegatives += (*iterator)->getSample()->getWeight();
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
            bestThreshold = (*iterator)->getValue();
            finalPolarity = currentPolarity;
        }
    }

    WeakClassifier *classifier = new WeakClassifier(feature, bestThreshold, finalPolarity, absoluteMinimumError);

    // Pulizia della memoria
    while (!tests.empty()) {
        delete tests.front();
        tests.pop_front();
    }
    tests.clear();

    return classifier;
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
    this->value = NAN;
}

double FeatureTest::getValue() {
    if (isnan(this->value)) {
        this->value = this->feature->value(this->sample);
    }
    return value;
}

bool FeatureTest::compare(FeatureTest *f1, FeatureTest *f2) {
    return f1->getValue() < f2->getValue();
}
