//
// Created by ilario on 11/06/15.
//

#include <iostream>
#include <Rectangle.h>
#include <Haar.h>

using namespace std;

void usage();

int main(int argc, char **argv) {

    if (argc < 4) {
        usage();
        exit(1);
    }

    Image *image = new Image(argv[1]);
    image->setWidth(atoi(argv[2]));
    image->setHeight(atoi(argv[3]));

    Image::floorRebase(image, image);
    Image::integralImage(image, image);
    Rectangle *r1 = new Rectangle(0, 0, 12, 24);
    Rectangle *r2 = new Rectangle(10, 30, 24, 12);

    cout << "vertical edge r1: " << Haar::verticalEdge(image, r1) << endl;
    cout << "horizontal edge r1: " << Haar::horizontalEdge(image, r1) << endl;
    cout << "vertical linear r1: " << Haar::verticalLinear(image, r1) << endl;
    cout << "horizontal linear r1: " << Haar::horizontalLinear(image, r1) << endl;

    return 0;
}

void usage() {
    cout << "Specificare la path dell'immagine, la larghezza e l'altezza" << endl;
}