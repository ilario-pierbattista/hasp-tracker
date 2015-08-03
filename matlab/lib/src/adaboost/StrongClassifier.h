//
// Created by ilario on 02/08/15.
//

#ifndef HASP_TRACKER_STRONGCLASSIFIER_H
#define HASP_TRACKER_STRONGCLASSIFIER_H

#include <iostream>

using namespace std;

/*
 * Struttura che descrive un classificatore debole
 * facente parte di un classificatore forte
 */
struct classifier_struct {
    WeakClassifier classifier;
    double alpha;
    double alphaSum;
};
typedef struct classifier_struct classifier_struct;

/*
 * La classe descrive un classificatore forte
 */
class StrongClassifier {
public:
    StrongClassifier(){};

    ~StrongClassifier(){};

    vector<classifier_struct> classifiers;
    unsigned int scaleFactor;
    double floorValue;
    Point innerOffset;
    Dimensions samplesSize;
};

#endif //HASP_TRACKER_STRONGCLASSIFIER_H
