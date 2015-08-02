//
// Created by ilario on 08/06/15.
//

#include <iostream>
#include <math.h>
#include "Interval.h"

Interval::Interval(int a, int b) {
    this->a = a;
    this->b = b;
}

/**
 * Divisione dell'intervallo in parti uguali
 */
vector<Interval *> Interval::split(int divider) throw(SplitException) {
    int part = 0;
    vector<Interval *> result;
    Interval *interval;
    if (this->length() % divider != 0) {
        throw new SplitException();
    }

    part = this->length() / divider;
    for (unsigned int i = 0; i < (unsigned int) divider; i++) {
        interval = new Interval(
                this->a + i * part,
                this->a + (i + 1) * part - 1
        );
        result.push_back(interval);
    }
    result.shrink_to_fit();

    return result;
}

/**
 * Lunghezza dell'intervallo
 */
unsigned int Interval::length() {
    return (unsigned int) fabs(b - a) + 1;
}

std::string Interval::to_string() {
    std::string stringa = "{a: " + std::to_string(this->a) +
                          " b: " + std::to_string(this->b) + "}";
    return stringa;
}