//
// Created by ilario on 08/06/15.
//

#include <string>
#include "Point.h"

Point::Point(int x, int y) {
    this->x = x;
    this->y = y;
}

std::string Point::to_string() {
    std::string string = "{x: " + std::to_string(this->x) +
                         " y: " + std::to_string(this->y) + "}";
    return string;
}