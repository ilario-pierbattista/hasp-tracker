//
// Created by ilario on 08/06/15.
//

#ifndef HASP_TRACKER_HAAR_H
#define HASP_TRACKER_HAAR_H

#include "image.h"
#include "geometry.h"

using namespace std;

class Haar {
public:

    Haar() { };

    Haar(Rectangle *r, int code);

    ~Haar();

    double value(Image *image);

    double value(Image *image, Point offset);

    string to_string();

    Haar *clone();

    static double verticalEdge(Image *image, Rectangle *rectangle);

    static double horizontalEdge(Image *image, Rectangle *rectangle);

    static double verticalLinear(Image *image, Rectangle *rectangle);

    static double horizontalLinear(Image *image, Rectangle *rectangle);

    static double calculateValue(Image *image, Rectangle *rectangle, int code);

    static const unsigned char VERTICAL_EDGE = 0;
    static const unsigned char HORIZONTAL_EDGE = 1;
    static const unsigned char VERTICAL_LINEAR = 2;
    static const unsigned char HORIZONTAL_LINEAR = 3;

    Rectangle *getArea() const {
        return area;
    }

    void setArea(Rectangle *area) {
        Haar::area = area;
    }

    unsigned char getCode() const {
        return code;
    }

    void setCode(unsigned char code) {
        Haar::code = code;
    }

private:
    static double calculateIntensity(Image *image, Rectangle *rectangle);

    static void clearRectangles(vector<Rectangle *> rects);

    Rectangle *area;
    unsigned char code;
};

#endif //HASP_TRACKER_HAAR_H
