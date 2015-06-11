//
// Created by ilario on 08/06/15.
//

#include <iostream>
#include <cmath>
#include "Haar.h"
#include "Rectangle.h"

double Haar::verticalEdge(Image *image, Rectangle *rectangle) {
    try {
        vector<Rectangle *> parts = rectangle->verticalSplit(2);
        double value =
                Haar::calculateIntensity(image, parts.at(0)) -
                Haar::calculateIntensity(image, parts.at(1));
        return value;
    } catch (exception &e) {
        return NAN;
    }
}

double Haar::horizontalEdge(Image *image, Rectangle *rectangle) {
    try {
        vector<Rectangle *> parts = rectangle->horizontalSplit(2);
        double value =
                Haar::calculateIntensity(image, parts.at(0)) -
                Haar::calculateIntensity(image, parts.at(1));
        return value;
    } catch (exception &e) {
        return NAN;
    }
}

double Haar::verticalLinear(Image *image, Rectangle *rectangle) {
    try {
        vector<Rectangle *> parts = rectangle->verticalSplit(3);
        double value =
                Haar::calculateIntensity(image, parts.at(0)) +
                Haar::calculateIntensity(image, parts.at(2)) -
                Haar::calculateIntensity(image, parts.at(1));
        return value;
    } catch (exception &e) {
        cout << e.what() << endl;
        return NAN;
    }
}

double Haar::horizontalLinear(Image *image, Rectangle *rectangle) {
    try {
        vector<Rectangle *> parts = rectangle->horizontalSplit(3);
        double value =
                Haar::calculateIntensity(image, parts.at(0)) +
                Haar::calculateIntensity(image, parts.at(2)) -
                Haar::calculateIntensity(image, parts.at(1));
        return value;
    } catch (exception &e) {
        return NAN;
    }
}

/**
 * calculateIntensity
 * Calcola l'intensità di un rettangolo su un'immagine integrale.
 * L'intensità di un'area è pari alla somma delle intensità dei singoli
 * pixel.
 * In un'immagine integrale tale somma è pari a: A + D - B - C
 *
 * A        B
 *  +------+
 *  |      |
 *  +------+
 * C        D
 */
double Haar::calculateIntensity(Image *image, Rectangle *rectangle) {
    return image->read(rectangle->bottomRightPoint()) +
           image->read(rectangle->topLeftPoint()) -
           image->read(rectangle->topRightPoint()) -
           image->read(rectangle->bottomLeftPoint());
}