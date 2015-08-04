//
// Created by ilario on 02/08/15.
//

#include "StrongClassifier.h"

StrongClassifier::StrongClassifier(
        vector<classifier_struct *> classifiers,
        Dimensions samplesSize,
        Point innerOffset,
        unsigned int scaleFactor,
        double alphaSum,
        double floorValue) {
    this->classifiers = classifiers;
    this->samplesSize = samplesSize;
    this->innerOffset = innerOffset;
    this->scaleFactor = scaleFactor;
    this->alphaSum = alphaSum;
    this->floorValue = floorValue;
}

