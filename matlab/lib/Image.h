//
// Created by ilario on 07/06/15.
//

#ifndef HASP_TRACKER_IMAGE_H
#define HASP_TRACKER_IMAGE_H


#include <zconf.h>
#include <exception>
#include "Point.h"
#include "exception/MemoryAccessException.h"

class Image {
public:
    /**
     * Constructors
     */
    Image();
    Image(double *image, const size_t *size);
    Image(double *image, int width, int height);
    Image(char *filePath);

    /**
     * Static methods for image processing
     */
    static void floorRebase(Image *origin, Image *destination);
    static void integralImage(Image *origin, Image *destination);

    /**
     * Object methods
     */
    double read(int index) throw (MemoryAccessException);
    double read(int x, int y) throw (MemoryAccessException);
    double read(Point *p) throw (MemoryAccessException);
    void write(double value, int index) throw (MemoryAccessException);
    void write(double value, int x, int y) throw (MemoryAccessException);
    void write(double value, Point *p) throw (MemoryAccessException);

    /**
     * Getters and setters
     */
    double *getImage();
    int getWidth();
    int getHeight();
    void setImage(double *image);
    void setWidth(int width);
    void setHeight(int height);
    void setSize(const size_t *size);

private:
    double *image;
    int width;
    int height;

    int coordinatesToIndex(int x, int y);
    int length();
};


#endif //HASP_TRACKER_IMAGE_H
