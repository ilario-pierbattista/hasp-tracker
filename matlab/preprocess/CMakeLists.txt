matlab_add_mex(
    NAME floor_rebase
    SRC floor_rebase.cxx
    LINK_TO image
)

matlab_add_mex(NAME integral_image SRC integral_image.cxx LINK_TO image)
matlab_add_mex(NAME scale_image SRC scale_image.cxx LINK_TO image)

#matlab_add_mex(
#    NAME array_fire_info
#    SRC array_fire_info.cxx
#    LINK_TO ${ArrayFire_LIBS}
#)