#include <stdio.h>
#include <math.h>
#include "mex.h"
#include "matrix.h"
#include "../include/general.h"

#ifndef _HAAR_LIKE_H_
#define _HAAR_LIKE_H_

struct H_edge {
    rectangle positive, negative;
    int area;
};
typedef struct H_edge H_edge;

rectangle createRectangle(int *x, int *y);
int rectangleArea(rectangle r);

#endif
