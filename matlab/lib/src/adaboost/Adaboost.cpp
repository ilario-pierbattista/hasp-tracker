//
// Created by ilario on 11/06/15.
//

#include <list>
#include <math.h>
#include "Adaboost.h"

using namespace std;

WeakClassifier *Adaboost::bestWeakClassifier(vector<Sample *> samples, vector<Haar *> features, float *values) {
    list<FeatureTest *> tests;
    list<FeatureTest *>::const_iterator testIterator;
    // Somme degli esempi positivi e negativi
    double positiveSum = 0, negativeSum = 0;
    WeakClassifier *bestClassifier = new WeakClassifier(),
            *weakClassifier;
    unsigned int sampleIndex;

    bestClassifier->weightedError = 1.0;

    for (unsigned int i = 0; i < samples.size(); i++) {
        tests.push_back(new FeatureTest());
        if (samples.at(i)->positive) {
            positiveSum += samples.at(i)->weight;
        } else {
            negativeSum += samples.at(i)->weight;
        }
    }

    for (unsigned int featureIndex = 0; featureIndex < features.size(); featureIndex++) {
        // Calcolo dei valori della feature per ciascuna immagine
        // Calcolo delle somme dei pesi
        for (testIterator = tests.begin(), sampleIndex = 0;
             testIterator != tests.end();
             testIterator++, sampleIndex++) {
            (*testIterator)->setFeature(features.at(featureIndex));
            (*testIterator)->setSample(samples.at(sampleIndex));

            if (values == nullptr) {
                (*testIterator)->calculateValue();
            } else {
                (*testIterator)->value = *(values + sampleIndex * features.size() + featureIndex);
            }
        }

        // Ordimento delle immagini in base al valore della feature (crescente)
        tests.sort(FeatureTest::compare);

        weakClassifier = Adaboost::lowestErrorThreshold(tests, positiveSum, negativeSum);
        weakClassifier->featureIndex = featureIndex;

        if (weakClassifier->weightedError < bestClassifier->weightedError) {
            delete bestClassifier;
            bestClassifier = weakClassifier;
        }
    }

    for (unsigned int i = 0; i < samples.size(); i++) {
        delete tests.front();
        tests.pop_front();
    }
    tests.clear();

    return bestClassifier;
}

WeakClassifier *Adaboost::lowestErrorThreshold(list<FeatureTest *> &tests, double positiveSum, double negativeSum) {
    double partialPos = 0,
            partialNeg = 0,
            errorBelowThreshold, errorOverThreshold,
            weightedError;
    short polarity;
    list<FeatureTest *>::iterator listIterator;
    WeakClassifier *weakClassifier = new WeakClassifier();
    weakClassifier->feature = (*tests.begin())->feature->clone();
    weakClassifier->weightedError = 1.0;

    for (listIterator = tests.begin(); listIterator != tests.end(); listIterator++) {
        // Aggiornamento delle somme dei pesi delle immagini sotto la soglia
        if ((*listIterator)->sample->positive) {
            partialPos += (*listIterator)->sample->weight;
        } else {
            partialNeg += (*listIterator)->sample->weight;
        }

        // Aggiornamento degli errori di classificazione al di sotto e al di sopra
        // della soglia
        errorBelowThreshold = partialNeg + positiveSum - partialPos;
        errorOverThreshold = partialPos + negativeSum - partialNeg;

        // Calcolo dell'errore relativo all'iterazione corrente
        // minore tra le due classificazioni
        if (errorBelowThreshold < errorOverThreshold) {
            weightedError = errorBelowThreshold;
            polarity = 1;
        } else {
            weightedError = errorOverThreshold;
            polarity = -1;
        }

        if (weightedError < weakClassifier->weightedError) {
            weakClassifier->weightedError = weightedError;
            weakClassifier->threshold = (*listIterator)->value;
            weakClassifier->polarity = polarity;
        }
    }

    return weakClassifier;
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
    double betaT;

    betaT = calculateBetaT(classifier);
    //cout << "Beta " << betaT;
    int correct = 0, nonCorrect = 0;

    /**
     * Da Viola-Jones
     * W_t+1,i = W_t,i * beta_t ^ (1 - e_i)
     * con e_i = 0 se l'esempio x_i viene classificato correttamente, uguale a 1 altrimenti
     * beta_t ^ (1 - e_i) = beta_t se e_i = 0
     * beta_t ^ (1 - e_i) = beta_t ^ 0 = 1 se e_i = 1
     */
    for (unsigned int i = 0; i < samples.size(); i++) {
        if (classifier->classify(samples.at(i)) == samples.at(i)->positive) {
            updatedWeights.at(i) = samples.at(i)->weight * betaT;
            correct++;
        } else {
            updatedWeights.at(i) = samples.at(i)->weight;
            nonCorrect++;
        }
        //cout << "Old weight " << samples.at(i)->weight << " New weight " << updatedWeights.at(i) << endl;
    }
    //cout << "Correct classifications " << correct << " uncorrect " << nonCorrect << endl;

    return updatedWeights;
}
