//
// Created by ilario on 24/06/15.
//

#include "WeakClassifier.h"
#include <math.h>

WeakClassifier::WeakClassifier(Haar *feature, double thr, short p, double weightedError) {
    this->feature = feature->clone();
    this->threshold = thr;
    this->polarity = p;
    this->weightedError = weightedError;
}

WeakClassifier::WeakClassifier() {
    this->feature = nullptr;
    this->threshold = NAN;
    this->weightedError = NAN;
    this->polarity = 0;
}

WeakClassifier::WeakClassifier(Haar *feature, double thr, short p) {
    this->feature = feature->clone();
    this->threshold = thr;
    this->polarity = p;
}

WeakClassifier::~WeakClassifier() {
    delete this->feature;
}

bool WeakClassifier::classify(Image *image, Point offset) {
    double value = this->feature->value(image, offset);
    return value * this->polarity < this->polarity * this->threshold;
}

bool WeakClassifier::classify(Image *image) {
    double value;
    value = this->feature->value(image);
    return value * this->polarity < this->polarity * this->threshold;
}
