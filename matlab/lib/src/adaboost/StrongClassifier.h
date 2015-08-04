//
// Created by ilario on 02/08/15.
//

#ifndef HASP_TRACKER_STRONGCLASSIFIER_H
#define HASP_TRACKER_STRONGCLASSIFIER_H

#include <iostream>
#include "WeakClassifier.h"

using namespace std;

/*
 * Struttura che descrive un classificatore debole
 * facente parte di un classificatore forte
 */
struct classifier_struct {
    WeakClassifier* classifier;
    double alpha;
    double alphaSum;
};
typedef struct classifier_struct classifier_struct;

/*
 * La classe descrive un classificatore forte
 */
class StrongClassifier {
public:
    StrongClassifier(
            vector<classifier_struct *> classifiers,
            Dimensions samplesSize,
            Point innerOffset,
            unsigned int scaleFactor,
            double alphaSum,
            double floorValue
    );

    // Empty constructor
    StrongClassifier() { };



    vector<classifier_struct *> classifiers;
    Dimensions samplesSize = Dimensions(0, 0);
    Point innerOffset = Point(0, 0);
    unsigned int scaleFactor;
    double alphaSum;
    double floorValue;
};

#endif //HASP_TRACKER_STRONGCLASSIFIER_H
