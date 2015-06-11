//
// Created by ilario on 08/06/15.
//

#ifndef HASP_TRACKER_POINT_H
#define HASP_TRACKER_POINT_H

#include <string>

class Point {
public:
    Point(int x, int y);

    std::string to_string();

    int x, y;
};


#endif //HASP_TRACKER_POINT_H
