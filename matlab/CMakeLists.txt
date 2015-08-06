# Cmake per le funzioni integrate in matlab
cmake_minimum_required(VERSION 3.2)

# Ricerca dell'installazione di matlab
include("${PROJECT_SOURCE_DIR}/cmake/FindMatlabCustom.cmake")
set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")
if(NOT Matlab_FOUND)
    matlab_get_version_from_release_name(R2014a MATLAB_MIN_VER)
    find_package(MatlabCustom ${MATLAB_MIN_VER} REQUIRED COMPONENTS MX_LIBRARY MEX_COMPILER)
endif()

if(NOT ArrayFire_FOUND)
    find_package(ArrayFire)
endif()

include_directories(${Matlab_INCLUDE_DIRS})
include_directories(${ArrayFire_INCLUDE_DIRS})

# Shared library prefix-suffix
set(CMAKE_SHARED_LIBRARY_SUFFIX ".${Matlab_MEX_EXTENSION}")
set(CMAKE_SHARED_LIBRARY_PREFIX)

# Compile options
set(CMAKE_CXX_FLAGS "-fPIC -std=c++11")

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${PROJECT_SOURCE_DIR}/matlab/mex")
set(CMAKE_BUILD_TYPE Debug)

# Setup dei file da compilare
include_directories(lib/include)

add_subdirectory(lib)
add_subdirectory(adaboost)
add_subdirectory(haar)
add_subdirectory(preprocess)