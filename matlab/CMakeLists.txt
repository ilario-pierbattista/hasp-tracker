
set(CMAKE_CXX_COMPILER mex)
set(CMAKE_C_COMPILER mex)

# Suffix and Prefix of the output target file
SET( CMAKE_SHARED_LIBRARY_SUFFIX .mexa64 )  # set suffix to .mexa64
SET( CMAKE_SHARED_LIBRARY_PREFIX )      # remove the "lib" prefix


# Variables controlling the build-phrase
SET( CMAKE_CXX_FLAGS "-silent -cxx -largeArrayDims CXXFLAGS='$$CXXFLAGS -Wall -std=c++11'" )
SET( CMAKE_SHARED_LIBRARY_CXX_FLAGS )       # remove the -fPIC option. mex does not accept the "-fPIC" option

#SET( CMAKE_CXX_COMPILE_OBJECT
#    "<CMAKE_CXX_COMPILER> <DEFINES> <FLAGS> -outdir <OBJECT_DIR> -c <SOURCE>; mv <OBJECT_DIR>/$$(basename <SOURCE> .cxx ).o <OBJECT>"
#)

SET( CMAKE_CXX_COMPILE_OBJECT
    "<CMAKE_CXX_COMPILER> <DEFINES> <FLAGS> -outdir <OBJECT_DIR> -c <SOURCE>; mv <OBJECT_DIR>/$$(basename <SOURCE> .cxx ).o <OBJECT> || echo same file"
)

# Variables controlling the linking-phase
SET( CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS )    # remove -shared options. mex does not accept the "-shared" option

SET(
    CMAKE_CXX_CREATE_SHARED_LIBRARY
    "<CMAKE_CXX_COMPILER> -cxx <LINK_FLAGS> <CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS> -output <TARGET> <OBJECTS> <LINK_LIBRARIES>"
)

# Variables controlling the installation RPATH
SET( CMAKE_INSTALL_RPATH "\$ORIGIN" )
# CMake will reset RPATH at the installation phase, so we need to specify CMAKE_INSTALL_RPATH

set( CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/mex")

MESSAGE( STATUS "mex.cmake is loaded.\n" )

add_subdirectory(adaboost)
add_subdirectory(haar)
add_subdirectory(preprocess)
