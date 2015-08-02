include_directories(include)
include_directories(src)

add_library(
    image
    STATIC
    src/image/Image.cpp
)

add_library(
    geometry
    STATIC
    src/geometry/Point.cpp
    src/geometry/Dimensions.cpp
    src/geometry/Interval.cpp
    src/geometry/Rectangle.cpp
)

add_library(
    feature
    STATIC
    src/feature/Haar.cpp
)

add_library(
    adaboost
    STATIC
    src/adaboost/Adaboost.cpp
    src/adaboost/WeakClassifier.cpp
    src/adaboost/StrongClassifier.cpp
    src/adaboost/Sample.cpp
)

add_library(
    mexutils
    STATIC
    src/mexutils/io.cpp
)

target_link_libraries(feature geometry image)
target_link_libraries(adaboost feature)