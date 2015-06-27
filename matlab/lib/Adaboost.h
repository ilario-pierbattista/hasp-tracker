//
// Created by ilario on 11/06/15.
//

#ifndef HASP_TRACKER_ADABOOST_H
#define HASP_TRACKER_ADABOOST_H

#include <vector>
#include "Sample.h"
#include "Haar.h"
#include "WeakClassifier.h"

using namespace std;

class Adaboost {
public:
    static WeakClassifier *bestWeakClassifier(vector<Sample *> samples, Haar *feature);

    static double calculateBetaT(double minimumError, double errorSmothing);

    static double calculateBetaT(double minimumError);

    static double calculateBetaT(WeakClassifier *classifier, vector<Sample *> samples);

    static double calculateBetaT(WeakClassifier *classifier);

    static vector<double> updateWeights(WeakClassifier *classifier, vector<Sample *> samples);
};


/**
 * FeatureTest
 * Combina l'oggetto software di una feature di haar con quello di un'immagine d'esempio
 */
class FeatureTest {
public:
    FeatureTest(Haar *feature, Sample *sample);

    double getValue();

    static bool compare(FeatureTest *f1, FeatureTest *f2);

    Haar *getFeature() const {
        return feature;
    }

    void setFeature(Haar *feature) {
        FeatureTest::feature = feature;
    }

    Sample *getSample() const {
        return sample;
    }

    void setSample(Sample *sample) {
        FeatureTest::sample = sample;
    }

private:
    Haar *feature;
    Sample *sample;
    double value;
};


#endif //HASP_TRACKER_ADABOOST_H