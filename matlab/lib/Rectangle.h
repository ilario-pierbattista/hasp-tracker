//
// Created by ilario on 08/06/15.
//
#include <vector>
#include <iostream>
#include <string>
#include "Point.h"
#include "Dimensions.h"
#include "Interval.h"

#ifndef HASP_TRACKER_RECTANGLE_H
#define HASP_TRACKER_RECTANGLE_H

using namespace std;

class Rectangle {
public:
    Rectangle(int x, int y, unsigned int width, unsigned height);

    Rectangle(Point p, unsigned int width, unsigned int height);

    Rectangle(Point p, Dimensions d);

    Point *topLeftPoint();

    Point *topRightPoint();

    Point *bottomLeftPoint();

    Point *bottomRightPoint();

    vector<Rectangle *> horizontalSplit(unsigned int divider
    ) throw(SplitException);

    vector<Rectangle *> verticalSplit(unsigned int divider
    ) throw(SplitException);

    Interval *xInterval();

    Interval *yInterval();

    string to_string();

    int x, y, width, height;
};


#endif //HASP_TRACKER_RECTANGLE_H
