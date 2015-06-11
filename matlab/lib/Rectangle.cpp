//
// Created by ilario on 08/06/15.
//

#include "Interval.h"
#include "Rectangle.h"

Rectangle::Rectangle(int x, int y, unsigned int width, unsigned height) {
    this->x = x;
    this->y = y;
    this->width = width;
    this->height = height;
}

Rectangle::Rectangle(Point p, unsigned int width, unsigned int height) {
    this->x = p.x;
    this->y = p.y;
    this->width = width;
    this->height = height;
}

Rectangle::Rectangle(Point p, Dimensions d) {
    this->x = p.x;
    this->y = p.y;
    this->width = d.width;
    this->height = d.height;
}

Point *Rectangle::topLeftPoint() {
    return new Point(this->x, this->y);
}

Point *Rectangle::topRightPoint() {
    return new Point(this->x + this->width - 1, this->y);
}

Point *Rectangle::bottomLeftPoint() {
    return new Point(this->x, this->y + this->height - 1);
}

Point *Rectangle::bottomRightPoint() {
    return new Point(this->x + this->width - 1, this->y + this->height - 1);
}

vector<Rectangle *> Rectangle::horizontalSplit(unsigned int divider)
throw(SplitException) {
    Interval *width = this->xInterval();
    vector<Interval *> intervals = width->split(divider);
    vector<Rectangle *> result(divider);

    for (unsigned int i = 0; i < divider; i++) {
        result.at(i) = new Rectangle(
                intervals.at(i)->a,
                this->y,
                intervals.at(i)->length(),
                this->height
        );
    }

    /** @TODO distruzione */
    return result;
}

vector<Rectangle *> Rectangle::verticalSplit(unsigned int divider)
throw(SplitException) {
    Interval *height = this->yInterval();
    vector<Interval *> intervals = height->split(divider);
    vector<Rectangle *> result(divider);

    for (unsigned int i = 0; i < divider; ++i) {
        result.at(i) = new Rectangle(
                this->x,
                intervals.at(i)->a,
                this->width,
                intervals.at(i)->length()
        );
    }

    return result;
}

Interval *Rectangle::xInterval() {
    Interval *interval;
    interval = new Interval(
            this->topLeftPoint()->x,
            this->topRightPoint()->x
    );
    return interval;
}

Interval *Rectangle::yInterval() {
    Interval *interval;
    interval = new Interval(
            this->topLeftPoint()->y,
            this->bottomLeftPoint()->y
    );
    return interval;
}

string Rectangle::to_string() {
    string stringa = "{x: " + std::to_string(this->x) +
                     ", y: " + std::to_string(this->y) +
                     ", width: " + std::to_string(this->width) +
                     ", height: " + std::to_string(this->height) +
                     ", top_left: " + this->topLeftPoint()->to_string() +
                     ", top_right: " + this->topRightPoint()->to_string() +
                     ", bottom_left: " + this->bottomLeftPoint()->to_string() +
                     ", bottom_right: " + this->bottomRightPoint()->to_string() + "}";
    return stringa;
}