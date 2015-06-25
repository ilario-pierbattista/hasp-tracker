cmake_minimum_required(VERSION 3.0)
project(hasp_tracker)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

include_directories(matlab/lib)
include_directories(/usr/local/MATLAB/R2014a/extern/include)

file(GLOB hasp_lib
"matlab/lib/*.h"
"matlab/lib/*.cpp"
"matlab/lib/exception/*.h"
"matlab/lib/exception/*.cpp"
"matlab/haar/*.cxx"
"matlab/adaboost/*.cxx"
"matlab/preprocess/*.cxx")

add_executable(hasp_tracker main.cpp ${hasp_lib})

