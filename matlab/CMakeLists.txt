cmake_minimum_required(VERSION 3.0)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

#set(CMAKE_MODULE_PATH ../cmake)
#find_package(Matlab)
#if(Matlab_FOUND)
#    message(STATUS 'Matlab found at ${MATLAB_INCLUDE_DIR}')
#else(Matlab_FOUND)
#    message(STATUS 'Matlab not found')
#endif()

if(UNIX)
    include_directories(/usr/local/MATLAB/current/extern/include)
elseif(WIN32)
    include_directories(C:/Program\ Files/MATLAB/MATLAB\ Production\ Server/R2015a/extern/include)
endif(UNIX)

# Suffisso diverso a seconda dell'architettura della
# macchina su cui si compila
if(CMAKE_SIZEOF_VOID_P MATCHES "8")
    SET( CMAKE_SHARED_LIBRARY_SUFFIX .mexa64 )  # set suffix to .mexa64
elseif(CMAKE_SIZEOF_VOID_P MATCHES "4")
    SET( CMAKE_SHARED_LIBRARY_SUFFIX .mexa32 )  # set suffix to .mexa32
endif(CMAKE_SIZEOF_VOID_P MATCHES "8")
SET( CMAKE_SHARED_LIBRARY_PREFIX )      # remove the "lib" prefix


if(UNIX)
    set(CMAKE_CXX_COMPILER mex)
    set(CMAKE_C_COMPILER mex)
    add_compile_options(-silent -cxx)
endif(UNIX)

# Variables controlling the build-phrase-
add_compile_options(${CXXFLAGS}  -Wall -std=c++11)
SET( CMAKE_SHARED_LIBRARY_CXX_FLAGS )       # remove the -fPIC option. mex does not accept the "-fPIC" option
set(CMAKE_C_OUTPUT_EXTENSION obj)

if(UNIX)
    SET( CMAKE_CXX_FLAGS "-largeArrayDims" )
    SET( CMAKE_CXX_COMPILE_OBJECT
        "<CMAKE_CXX_COMPILER> <DEFINES> <FLAGS> -outdir <OBJECT_DIR> -c <SOURCE>; \
         mv <OBJECT_DIR>/$$(basename <SOURCE> .cxx ).o <OBJECT> || echo same file"
    )
    SET( CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS )
    SET(
        CMAKE_CXX_CREATE_SHARED_LIBRARY
        "<CMAKE_CXX_COMPILER> -cxx <LINK_FLAGS> <CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS> -output <TARGET> <OBJECTS> <LINK_LIBRARIES>"
    )
elseif(WIN32)
    SET( CMAKE_CXX_COMPILE_OBJECT
        "<CMAKE_CXX_COMPILER> <DEFINES> <FLAGS> -o <OBJECT> -c <SOURCE>;"
    )
endif(UNIX)

# Variables controlling the linking-phase
# SET( CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS )    # remove -shared options. mex does not accept the "-shared" option



# Variables controlling the installation RPATH
SET( CMAKE_INSTALL_RPATH "\$ORIGIN" )
# CMake will reset RPATH at the installation phase, so we need to specify CMAKE_INSTALL_RPATH

set( CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/mex")

MESSAGE( STATUS "mex.cmake is loaded.\n" )

include_directories(lib)

add_subdirectory(lib)
add_subdirectory(adaboost)
add_subdirectory(haar)
add_subdirectory(preprocess)
