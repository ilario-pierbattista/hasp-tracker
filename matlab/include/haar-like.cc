
#include "haar-like.h"

/* Crea la rappresentazione di un rettangolo */
rectangle createRectangle(int *x, int *y) {
    rectangle r;
    point* points = new point[4];
    for(int i = 0; i < 4; i++) {
        points[i].x = *(x+i);
        points[i].y = *(y+i);
    }
    r.tl = points[0];
    r.bl = points[1];
    r.tr = points[2];
    r.br = points[3];
    return r;
}

int rectangleArea(rectangle r) {
    return (r.tr.x - r.tl.x) * (r.tl.y - r.bl.y);
}
