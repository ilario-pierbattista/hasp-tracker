//
// Created by ilario on 08/06/15.
//

#ifndef HASP_TRACKER_DIMENSIONS_H
#define HASP_TRACKER_DIMENSIONS_H

#include <iostream>

using namespace std;

class Dimensions {
public:
    Dimensions(unsigned int width, unsigned int height);

    string to_string();

    unsigned int width, height;
};


#endif //HASP_TRACKER_DIMENSIONS_H
