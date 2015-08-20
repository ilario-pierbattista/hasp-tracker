//
// Created by ilario on 11/06/15.
//

#ifndef HASP_TRACKER_ADABOOST_H
#define HASP_TRACKER_ADABOOST_H

#include <vector>
#include <list>
#include "WeakClassifier.h"
#include "FeatureTest.h"
#include "Sample.h"
#include "feature.h"
#include "../mexutils/utils.h"

using namespace std;

class Adaboost {
public:
    static WeakClassifier *bestWeakClassifier(vector<Sample *> samples, vector<Haar *> features, float *values);

    static WeakClassifier *bestWeakClassifier(vector<Sample *> samples, vector<Haar *> features);

    static double calculateBetaT(double minimumError, double errorSmothing);

    static double calculateBetaT(double minimumError);

    static double calculateBetaT(WeakClassifier *classifier, vector<Sample *> samples);

    static double calculateBetaT(WeakClassifier *classifier);

    static vector<double> updateWeights(WeakClassifier *classifier, vector<Sample *> samples);

private:
    static WeakClassifier *lowestErrorThreshold(
            list<FeatureTest *> &tests,
            double positiveSum,
            double negativeSum
    );
};

#endif //HASP_TRACKER_ADABOOST_H
