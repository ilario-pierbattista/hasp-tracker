cmake_minimum_required(VERSION 3.0)
project(hasp_tracker)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

include_directories(matlab/lib)

file(GLOB hasp_lib
"matlab/lib/*.h"
"matlab/lib/*.cpp"
"matlab/lib/exception/*.h"
"matlab/lib/exception/*.cpp")

add_executable(hasp_tracker main.cpp ${hasp_lib})

