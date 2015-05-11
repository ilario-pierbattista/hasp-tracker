cmake_minimum_required(VERSION 3.2)
project(hasp)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE_FILES src/main.cpp)
add_executable(hasp ${SOURCE_FILES} src/headers/image.h src/modules/Image.cpp src/modules/Image.h)