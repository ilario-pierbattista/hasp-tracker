//
// Created by ilario on 07/06/15.
//

#include <iostream>
#include <fstream>
#include "Image.h"

using namespace std;

/**
 * Constructors
 */
Image::Image() { }

Image::Image(double *image, const size_t *size) {
    this->image = image;
    this->setSize(size);
}

Image::Image(double *image, int width, int height) {
    this->image = image;
    this->width = width;
    this->height = height;
}

Image::Image(char *filePath) {
    ifstream imageStream;
    streampos begin, end;
    int size = 0, i = 0;
    char *buff = new char[2];
    unsigned char lsb, msb;
    unsigned int value;

    imageStream.open(filePath, ios::in | ios::binary);
    if(imageStream.good()) {

        // Impostazione della dimensione
        begin = imageStream.tellg();
        imageStream.seekg(0, ios::end);
        end = imageStream.tellg();
        size = ( (int) end - begin ) / 2;
        this->image = new double[size];
        this->width = size;
        this->height = 1;

        // Posizionamento all'inizio del file
        imageStream.seekg(0, ios::beg);

        // Lettura del contenuto del file
        while(imageStream.good()) {
            imageStream.read(buff, 2);
            msb = (unsigned char) buff[1];
            lsb = (unsigned char) buff[0];
            value = (unsigned int) msb << CHAR_BIT | lsb;
            *(this->image + i++) = (double) value;
        }

        imageStream.close();
    } else {
        cout << "Impossibile aprire il file" << endl;
    }
}

Image::~Image() {
    /*@TODO distruttore */
}

/**
 * floorRebase
 * Ricerca il punto di massimo dell'immagine di profondità e,
 * assumendo che questo sia il valore della quota del pavimento,
 * converte tutti gli altri pixel in quote dal pavimento stesso.
 */
void Image::floorRebase(Image *origin, Image *destination) {
    try {
        int length = origin->getWidth() * origin->getHeight();
        double floor = 0;

        // Ricerca del massimo
        for (int i = 0; i < length; i++) {
            if (origin->read(i) > floor) {
                floor = origin->read(i);
            }
        }

        // Riscrittura delle quote
        for (int i = 0; i < length; i++) {
            destination->write(floor - origin->read(i), i);
        }
    } catch (std::exception &e) {
        std::cout << e.what() << std::endl;
    }
}

/**
 * integralImage
 * Genera l'immagine integrale
 */
void Image::integralImage(Image *origin, Image *destination) {
    try {
        double value = origin->read(0);
        // Punto in alto a sinistra
        destination->write(value, 0);

        // Fila di pixel in alto
        for (int x = 1; x < origin->getWidth(); x++) {
            value = origin->read(x, 0) +
                    destination->read(x - 1, 0);
            destination->write(value, x, 0);
        }

        // Fila di pixel laterali
        for (int y = 1; y < origin->getHeight(); y++) {
            value = origin->read(0, y) +
                    destination->read(0, y - 1);
            destination->write(value, 0, y);
        }

        // Ciclo per gli altri pixel
        for (int y = 1; y < origin->getHeight(); y++) {
            for (int x = 1; x < origin->getWidth(); x++) {
                value = origin->read(x, y) +
                        destination->read(x - 1, y) +
                        destination->read(x, y - 1) -
                        destination->read(x - 1, y - 1);
                destination->write(value, x, y);
            }
        }
    } catch (std::exception &e) {
        std::cout << e.what() << std::endl;
    }
}

/**
 * Lettura di un pixel
 */
double Image::read(int x, int y) throw (MemoryAccessException) {
    return this->read(this->coordinatesToIndex(x, y));
}

double Image::read(int index) throw (MemoryAccessException) {
    if(index < 0 || index >= this->length()) {
        throw new MemoryAccessException();
    }
    return *(this->image + index);
}

double Image::read(Point p) throw (MemoryAccessException) {
    return this->read(p.x, p.y);
}

/**
 * Scrittura di un pixel
 */
void Image::write(double value, int x, int y) throw (MemoryAccessException) {
    this->write(value, this->coordinatesToIndex(x, y));
}

void Image::write(double value, int index) throw (MemoryAccessException) {
    if(index < 0 || index >= this->length()) {
        throw new MemoryAccessException();
    }
    *(this->image + index) = value;
}

void Image::write(double value, Point *p) throw (MemoryAccessException) {
    this->write(value, p->x, p->y);
}

/**
 * Trasforma le coordinate dell'immagine in un
 * indice dell'array di double
 */
int Image::coordinatesToIndex(int x, int y) {
    return x * this->height + y;
}

/**
 * Getters and setters
 */
double *Image::getImage() {
    return this->image;
}

int Image::getWidth() {
    return this->width;
}

int Image::getHeight() {
    return this->height;
}

void Image::setImage(double *image) {
    this->image = image;
}

void Image::setWidth(int width) {
    this->width = width;
}

void Image::setHeight(int height) {
    this->height = height;
}

void Image::setSize(const size_t *size) {
    this->height = (int) size[0];
    this->width = (int) size[1];
}

int Image::length() {
    return this->width * this->height;
}