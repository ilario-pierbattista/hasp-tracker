//
// Created by ilario on 08/06/15.
//

#ifndef HASP_TRACKER_INTERVAL_H
#define HASP_TRACKER_INTERVAL_H

#include <iostream>
#include <vector>
#include <string>
#include "exception/SplitException.h"
#include "to_string_patch.h"

using namespace std;

class Interval {
public:
    Interval(int a, int b);

    vector<Interval *> split(int divider) throw(SplitException);

    unsigned int length();

    std::string to_string();

    int a, b;
};


#endif //HASP_TRACKER_INTERVAL_H
