//
// Created by ilario on 11/06/15.
//

#include "Sample.h"

using namespace std;

Sample::Sample(double *image, const size_t *size, bool positive, double weight)
        : Image(image, size) {
    this->positive = positive;
    this->weight = weight;
}

Sample::Sample(double *image, int width, int height, bool positive, double weight)
        : Image(image, width, height) {
    this->positive = positive;
    this->weight = weight;
}

Sample::Sample(char *filePath, bool positive, double weight)
        : Image(filePath) {
    this->positive = positive;
    this->weight = weight;
}

Sample::~Sample() {
    /* @TODO distruttore */
}

string Sample::to_string() {
    return "{positive: " + std::to_string(this->positive) +
                           ", weight: " + std::to_string(this->weight) + "}";
}
