#include <stdio.h>
#include <stdbool.h>
#include <math.h>
#include "mex.h"

#ifndef _GENERAL_H_
#define _GENERAL_H_

struct point {
    int x;
    int y;
};
typedef struct point point;

struct rectangle {
    point tl, tr, bl, br;
};
typedef struct rectangle rectangle;

#endif
