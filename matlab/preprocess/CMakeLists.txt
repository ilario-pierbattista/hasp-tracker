add_library(floor_rebase SHARED floor_rebase.cxx)
add_library(integral_image SHARED integral_image.cxx)

# image è la libreria in lib
target_link_libraries(floor_rebase image)
target_link_libraries(integral_image image)
