cmake_minimum_required(VERSION 3.2)
project(hasp_tracker)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

add_executable(hasp_tracker ${SOURCE_FILES} c++/src/Haar.cpp c++/include/Haar.h c++/src/Image.cpp c++/include/Image.h)