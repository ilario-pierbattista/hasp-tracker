/*
 * =====================================================================================
 *
 *       Filename:  feature-count.c
 *
 *    Description:
 *
 *        Version:  1.0
 *        Created:  10/05/2015 11:52:41
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Ilario Pierbattista (), pierbattista.ilario@gmail.com
 *   Organization:
 *
 * =====================================================================================
 */

#include <stdio.h>
int main() {
    int i, x, y, sizeX, sizeY, width, height, count, c;

    /*  All five shape types */
    const int features = 4;
    const int feature[][2] = {{2,1}, {1,2}, {3,1}, {1,3}, {2,2}};
    const int frameSize = 100;

    count = 0;
    /*  Each shape */
    for (i = 0; i < features; i++) {
        sizeX = feature[i][0];
        sizeY = feature[i][1];
        printf("%dx%d shapes:\n", sizeX, sizeY);

        /*  each size (multiples of basic shapes) */
        for (width = sizeX; width <= frameSize; width+=sizeX) {
            for (height = sizeY; height <= frameSize; height+=sizeY) {
                printf("\tsize: %dx%d => ", width, height);
                c=count;

                /*  each possible position given size */
                for (x = 0; x <= frameSize-width; x++) {
                    for (y = 0; y <= frameSize-height; y++) {
                        count++;

                    }

                }
                printf("count: %d\n", count-c);
            }
        }
    }
    printf("%d\n", count);

    return 0;
}
