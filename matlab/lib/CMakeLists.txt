add_library(geometry STATIC Rectangle.cpp Point.cpp Dimensions.cpp Interval.cpp to_string_patch.h)
add_library(image STATIC Image.cpp)
add_library(haar STATIC Haar.cpp)
add_library(adaboost STATIC Adaboost.cpp Sample.cpp WeakClassifier.cpp)

target_link_libraries(image geometry)
target_link_libraries(haar image geometry)
target_link_libraries(adaboost haar image)

add_subdirectory(mapping)