//
// Created by ilario on 11/06/15.
//

#ifndef HASP_TRACKER_SAMPLE_H
#define HASP_TRACKER_SAMPLE_H

#include <iostream>
#include "image.h"

using namespace std;


class Sample : public Image {
public:
    Sample() { };

    Sample(double *image, const size_t *size, bool positive, double weight);

    Sample(double *image, int width, int height, bool positive, double weight);

    Sample(char *filePath, bool positive, double weight);

    ~Sample();

    bool isPositive() const {
        return positive;
    }

    void setPositive(bool positive) {
        Sample::positive = positive;
    }

    double getWeight() const {
        return weight;
    }

    void setWeight(double weight) {
        Sample::weight = weight;
    }

    string to_string();

    bool positive;
    double weight;
};


#endif //HASP_TRACKER_SAMPLE_H
