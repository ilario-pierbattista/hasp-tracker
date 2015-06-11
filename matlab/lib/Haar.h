//
// Created by ilario on 08/06/15.
//

#ifndef HASP_TRACKER_HAAR_H
#define HASP_TRACKER_HAAR_H

#include <zconf.h>
#include "Image.h"
#include "Rectangle.h"

class Haar {
public:
    static double verticalEdge(Image *image, Rectangle *rectangle);
    static double horizontalEdge(Image *image, Rectangle *rectangle);
    static double verticalLinear(Image *image, Rectangle *rectangle);
    static double horizontalLinear(Image *image, Rectangle *rectangle);

private:
    static double calculateIntensity(Image *image, Rectangle *rectangle);
};


#endif //HASP_TRACKER_HAAR_H
