//
// Created by ilario on 08/06/15.
//

#include "Dimensions.h"

Dimensions::Dimensions(unsigned int width, unsigned int height) {
    this->width = width;
    this->height = height;
}

string Dimensions::to_string() {
    string stringa = "{width: " + std::to_string(this->width) +
                     " height: " + std::to_string(this->height) + "}";
    return stringa;
}
