//
// Created by ilario on 24/06/15.
//

#ifndef HASP_TRACKER_WEAKCLASSIFIER_H
#define HASP_TRACKER_WEAKCLASSIFIER_H


#include "Haar.h"

class WeakClassifier {
public:
    WeakClassifier(Haar *feature, double thr, short p, double weightedError);

    WeakClassifier(Haar *feature, double thr, short p);

    WeakClassifier();

    ~WeakClassifier();

    bool classify(Image *image);

    Haar *getFeature() const {
        return feature;
    }

    void setFeature(Haar *feature) {
        WeakClassifier::feature = feature;
    }

    double getThreshold() const {
        return threshold;
    }

    void setThreshold(double threshold) {
        WeakClassifier::threshold = threshold;
    }

    short getPolarity() const {
        return polarity;
    }

    void setPolarity(short polarity) {
        WeakClassifier::polarity = polarity;
    }

    double getWeightedError() const {
        return weightedError;
    }

    void setWeightedError(double weightedError) {
        WeakClassifier::weightedError = weightedError;
    }

    Haar *feature;
    int featureIndex;
    double threshold;
    short polarity;
    double weightedError;
};


#endif //HASP_TRACKER_WEAKCLASSIFIER_H
