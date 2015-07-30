//
// Created by Ilario on 30/07/2015.
//

#ifndef HASP_TRACKER_TO_STRING_PATCH_H
#define HASP_TRACKER_TO_STRING_PATCH_H

#ifdef __MINGW32__
#include <string>
#include <sstream>

namespace std
{
    template < typename T > std::string to_string( const T& n )
    {
        std::ostringstream stm ;
        stm << n ;
        return stm.str() ;
    }
}
#endif

#endif //HASP_TRACKER_TO_STRING_PATCH_H
