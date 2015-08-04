# Cmake di livello massimo
cmake_minimum_required(VERSION 3.2)
project(hasp_tracker)

set(CMAKE_CXX_FLAGS "-std=c++11")
set(LINKER_LANGUAGE CXX)

add_compile_options(-g)

include_directories(matlab/lib)
add_subdirectory(matlab)