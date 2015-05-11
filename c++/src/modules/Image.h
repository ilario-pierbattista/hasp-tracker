//
// Created by ilario on 10/05/15.
//

#ifndef HASP_IMAGE_H
#define HASP_IMAGE_H


class Image {
public:
    Image(char *filename, int width, int height);

private:
    char *fileName;
    int width, heigth;
};


#endif //HASP_IMAGE_H
