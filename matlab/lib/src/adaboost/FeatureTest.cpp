//
// Created by ilario on 20/08/15.
//

#include "FeatureTest.h"

/**
 * Implementazioni di FeatureTest
 */
FeatureTest::FeatureTest(Haar *feature, Sample *sample) {
    this->feature = feature;
    this->sample = sample;
    this->calculateValue();
}

void FeatureTest::calculateValue() {
    this->value = this->feature->calculateValue(this->sample);
}

bool FeatureTest::testValue() {
    return this->feature->calculateValue(this->sample) == this->value;
}

bool FeatureTest::compare(FeatureTest *f1, FeatureTest *f2) {
    return f1->value < f2->value;
}