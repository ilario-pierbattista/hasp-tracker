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
        double floorValue,
        int length,
        double threshold) {
    this->classifiers = classifiers;
    this->samplesSize = samplesSize;
    this->innerOffset = innerOffset;
    this->scaleFactor = scaleFactor;
    this->alphaSum = alphaSum;
    this->floorValue = floorValue;
    this->length = length;
    this->threshold = threshold;
}

StrongClassifier::~StrongClassifier() {
    classifier_struct *struttura;
    for (unsigned int i = 0; i < this->classifiers.size(); i++) {
        struttura = this->classifiers.at(i);
        delete struttura->classifier;
        delete struttura;
    }
    this->classifiers.empty();
}

bool StrongClassifier::classify(Image *image, Point *offset) {
    bool presence;
    double value = 0;
    classifier_struct *classData = this->classifiers.at(0);

    for (unsigned int i = 0; i < this->length; i++) {
        classData = this->classifiers.at(i);
        value += ((int) classData->classifier->classify(image, *offset)) * classData->alpha;
    }

    // A questo punto, classData contiene l'ultima struttura puntata
    presence = value > this->threshold * classData->alphaSum;
    return presence;
}
