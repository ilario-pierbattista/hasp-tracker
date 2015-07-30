cmake_minimum_required(VERSION 3.0)
project(hasp_tracker)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(CMAKE_MODULE_PATH cmake)
find_package(Matlab)
message(STATUS 'include dir ${MATLAB_INCLUDE_DIR}')

include_directories(matlab/lib)
if(UNIX)
    include_directories(/usr/local/MATLAB/current/extern/include)
elseif(WIN32)
    include_directories(C:\\Program Files\\MATLAB\\MATLAB Production Server\\R2015a\\extern\\include)
    include_directories(MATLAB_INCLUDE_DIR)
endif(UNIX)

file(GLOB hasp_lib
"matlab/lib/*.h"
"matlab/lib/*.cpp"
"matlab/lib/exception/*.h"
"matlab/lib/exception/*.cpp"
"matlab/lib/mapping/*.h"
"matlab/lib/mapping/*.cpp"
"matlab/haar/*.cxx"
"matlab/adaboost/*.cxx"
"matlab/preprocess/*.cxx")

add_subdirectory(matlab)


add_executable(hasp_tracker main.cpp)
target_link_libraries(hasp_tracker)
