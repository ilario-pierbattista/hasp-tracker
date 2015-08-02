//
// Created by ilario on 11/06/15.
//

#ifndef HASP_TRACKER_MEMORYACCESSEXCEPTION_H
#define HASP_TRACKER_MEMORYACCESSEXCEPTION_H


class MemoryAccessException {
public:
    virtual const char *what() const throw() {
        return "L'accesso a questa area di memoria non è consentito";
    }
};


#endif //HASP_TRACKER_MEMORYACCESSEXCEPTION_H
