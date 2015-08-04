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

Rectangle *Rectangle::clone() {
    Rectangle *copy = new Rectangle(
            this->topLeftPoint(),
            this->getDimension()
    );
    return copy;
}

void Rectangle::translate(Point p) {
    this->x += p.x;
    this->y += p.y;
}

Dimensions Rectangle::getDimension() {
    Dimensions dims(
            (unsigned int) this->width,
            (unsigned int) this->height
    );
    return dims;
}

Point Rectangle::topLeftPoint() {
    Point tl(this->x, this->y);
    return tl;
}

Point Rectangle::topRightPoint() {
    Point tr(this->x + this->width - 1, this->y);
    return tr;
}

Point Rectangle::bottomLeftPoint() {
    Point bl(this->x, this->y + this->height - 1);
    return bl;
}

Point Rectangle::bottomRightPoint() {
    Point br(this->x + this->width - 1, this->y + this->height - 1);
    return br;
}

vector<Rectangle *> Rectangle::horizontalSplit(unsigned int divider)
throw(SplitException) {
    Interval width = this->xInterval();
    vector<Interval *> intervals = width.split(divider);
    vector<Rectangle *> result(divider);

    for (unsigned int i = 0; i < divider; i++) {
        result.at(i) = new Rectangle(
                intervals.at(i)->a,
                this->y,
                intervals.at(i)->length(),
                this->height
        );
    }

    Rectangle::cleanIntervals(intervals);
    intervals.clear();

    return result;
}

vector<Rectangle *> Rectangle::verticalSplit(unsigned int divider)
throw(SplitException) {
    Interval height = this->yInterval();
    vector<Interval *> intervals = height.split(divider);
    vector<Rectangle *> result(divider);

    for (unsigned int i = 0; i < divider; ++i) {
        result.at(i) = new Rectangle(
                this->x,
                intervals.at(i)->a,
                this->width,
                intervals.at(i)->length()
        );
    }

    Rectangle::cleanIntervals(intervals);
    intervals.clear();

    return result;
}

Interval Rectangle::xInterval() {
    Interval interval(
            this->topLeftPoint().x,
            this->topRightPoint().x
    );
    return interval;
}

Interval Rectangle::yInterval() {
    Interval interval(
            this->topLeftPoint().y,
            this->bottomLeftPoint().y
    );
    return interval;
}

string Rectangle::to_string() {
    string stringa = "{x: " + std::to_string(this->x) +
                     ", y: " + std::to_string(this->y) +
                     ", width: " + std::to_string(this->width) +
                     ", height: " + std::to_string(this->height) +
                     ", top_left: " + this->topLeftPoint().to_string() +
                     ", top_right: " + this->topRightPoint().to_string() +
                     ", bottom_left: " + this->bottomLeftPoint().to_string() +
                     ", bottom_right: " + this->bottomRightPoint().to_string() + "}";
    return stringa;
}

void Rectangle::cleanIntervals(vector<Interval *> intervals) {
    for (unsigned int i = 0; i < intervals.size(); i++) {
        delete intervals.at(i);
    }
}
