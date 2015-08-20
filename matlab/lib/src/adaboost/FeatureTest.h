//
// Created by ilario on 20/08/15.
//

#ifndef HASP_TRACKER_FEATURETEST_H
#define HASP_TRACKER_FEATURETEST_H

#include "feature.h"
#include "Sample.h"

/**
 * FeatureTest
 * Combina l'oggetto software di una feature di haar con quello di un'immagine d'esempio
 */
class FeatureTest {
public:
    FeatureTest(Haar *feature, Sample *sample);

    FeatureTest() { };

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

    void calculateValue();

    bool testValue();

    Haar *feature;
    Sample *sample;
    double value;
};
#endif //HASP_TRACKER_FEATURETEST_H
