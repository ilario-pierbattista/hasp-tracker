# Cmake per le funzioni integrate in matlab
cmake_minimum_required(VERSION 3.2)

# Ricerca dell'installazione di matlab
include("${PROJECT_SOURCE_DIR}/cmake/FindMatlabCustom.cmake")
set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

macro( matlab_config )
     message( "Matlab_INCLUDE_DIR = ${Matlab_INCLUDE_DIR}" )
     set(BUILD_64BIT TRUE)
     if( BUILD_64BIT )
         set( LIB_DIR win64 )
         message( "BUILDING FOR 64 bit Windows" )
     else(BUILD_64BIT)
         set( LIB_DIR win32 )
         message( "BUILDING FOR 32 bit Windows" )
     endif(BUILD_64BIT)
     SET( Matlab_ROOT_DIR
     "C:\\Program Files\\MATLAB\\MATLAB Production Server\\R2015a" CACHE STRING "" )
     SET( Matlab_INCLUDE_DIR "${MATLAB_ROOT_DIR}\\extern\\include" CACHE STRING "" FORCE )

     find_library(Matlab_LIB_DIR libmx.lib PATHS ${Matlab_ROOT_DIR} ${Matlab_ROOT_DIR}/extern/lib/${LIB_DIR}/microsoft )
     #message("Matlab_LIB_DIR = ${Matlab_ROOT_DIR}/extern/lib/${LIB_DIR}/microsoft" )
     message("Matlab_LIB_DIR = ${Matlab_LIB_DIR}" )
     #message("matlab lib dir = ${Matlab_ROOT_DIR}/extern/lib/${LIB_DIR}" )

     SET( Matlab_LIBRARIES ${Matlab_ROOT_DIR}/bin/${LIB_DIR} CACHE
STRING "" FORCE )
     SET( Matlab_MEX_LIBRARY ${Matlab_ROOT_DIR}/bin/${LIB_DIR}/libmx.dll CACHE STRING "" FORCE )
     SET( Matlab_MX_LIBRARY ${Matlab_ROOT_DIR}/bin/${LIB_DIR}/libmex.dll CACHE STRING "" FORCE )
endmacro()

if(NOT Matlab_FOUND)
    matlab_get_version_from_release_name(R2014a MATLAB_MIN_VER)
    if(NOT UNIX)
        matlab_config()
        #set(Matlab_ROOT_DIR "C:/Program Files/MATLAB/MATLAB Production Server/R2015a")
        #set(Matlab_MEX_LIBRARY "${Matlab_ROOT_DIR}/extern/lib/${LIB_DIR}/microsoft")
    else(NOT UNIX)
        find_package(MatlabCustom ${MATLAB_MIN_VER} REQUIRED COMPONENTS MEX_COMPILER)
    endif()
endif()

include_directories(${Matlab_INCLUDE_DIRS})

# Shared library prefix-suffix
set(CMAKE_SHARED_LIBRARY_SUFFIX ".${Matlab_MEX_EXTENSION}")
set(CMAKE_SHARED_LIBRARY_PREFIX)

# Compile options
set(CMAKE_CXX_FLAGS "-fPIC -std=c++11")

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${PROJECT_SOURCE_DIR}/matlab/mex")

include_directories(lib)

add_subdirectory(lib)
add_subdirectory(adaboost)
add_subdirectory(haar)
add_subdirectory(preprocess)
