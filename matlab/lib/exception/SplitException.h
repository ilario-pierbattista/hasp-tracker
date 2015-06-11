//
// Created by ilario on 11/06/15.
//

#ifndef HASP_TRACKER_SPLITEXCEPTION_H
#define HASP_TRACKER_SPLITEXCEPTION_H

#include <exception>

class SplitException : public std::exception{
public:
    virtual const char *what() const throw() {
        return "L'intervallo specificato non è divisibile per tale numero.";
    }
};


#endif //HASP_TRACKER_SPLITEXCEPTION_H
