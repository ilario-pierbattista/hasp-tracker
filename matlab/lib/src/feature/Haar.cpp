//
// Created by ilario on 08/06/15.
//

#include <iostream>
#include <cmath>
#include <bits/unique_ptr.h>
#include "Haar.h"

using namespace std;

Haar::Haar(Rectangle *r, int code) {
    this->area = r;
    this->code = (unsigned char) code;
}

Haar::~Haar() {
    delete this->area;
}

double Haar::calculateValue(Image *image) {
    return Haar::calculateValue(image, this->area, this->code);
}

double Haar::calculateValue(Image *image, Point offset) {
    double value = 0;
    Rectangle *rectangle = this->area->clone();
    rectangle->translate(offset);
    value = Haar::calculateValue(image, rectangle, this->code);
    return value;
}

string Haar::to_string() {
    string stringa = "{ area: " + this->area->to_string() +
                     ", code: " + std::to_string(this->code) + "}";
    return stringa;
}

Haar *Haar::clone() {
    Rectangle *r = new Rectangle(this->getArea()->x,
                                 this->getArea()->y,
                                 (unsigned int) this->getArea()->width,
                                 (unsigned int) this->getArea()->height);
    Haar *copy = new Haar(r, this->code);
    return copy;
}

double Haar::verticalEdge(Image *image, Rectangle *rectangle) {
    try {
        vector<Rectangle *> parts = rectangle->verticalSplit(2);
        double value =
                Haar::calculateIntensity(image, parts.at(0)) -
                Haar::calculateIntensity(image, parts.at(1));
        Haar::clearRectangles(parts);
        parts.clear();
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
        Haar::clearRectangles(parts);
        parts.clear();
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
        Haar::clearRectangles(parts);
        parts.clear();
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
        Haar::clearRectangles(parts);
        parts.clear();
        return value;
    } catch (exception &e) {
        return NAN;
    }
}

/**
 * Calcola la feature di haar corrispondente al codice passato
 */
double Haar::calculateValue(Image *image, Rectangle *rectangle, int code) {
    double value;
    switch (code) {
        case Haar::VERTICAL_EDGE: {
            value = Haar::verticalEdge(image, rectangle);
            break;
        };
        case Haar::HORIZONTAL_EDGE: {
            value = Haar::horizontalEdge(image, rectangle);
            break;
        };
        case Haar::VERTICAL_LINEAR: {
            value = Haar::verticalLinear(image, rectangle);
            break;
        };
        case Haar::HORIZONTAL_LINEAR: {
            value = Haar::horizontalLinear(image, rectangle);
            break;
        };
        default: {
            value = NAN;
        }
    }
    return value;
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

void Haar::clearRectangles(vector<Rectangle *> rects) {
    for (unsigned int i = 0; i < rects.size(); i++) {
        delete rects.at(i);
    }
}
