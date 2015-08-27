add_compile_options(-largeArrayDims)

matlab_add_mex(
        NAME get_features
        SRC get_features.cxx
)

matlab_add_mex(
        NAME best_weak_classifier
        SRC best_weak_classifier.cxx
        LINK_TO adaboost mexutils
)

matlab_add_mex(
        NAME calculate_features
        SRC calculate_features.cxx
        LINK_TO adaboost mexutils
)

matlab_add_mex(
        NAME weak_classify_samples
        SRC weak_classify_samples.cxx
        LINK_TO mexutils
)

matlab_add_mex(
        NAME strong_classify
        SRC strong_classify.cxx
        LINK_TO adaboost mexutils
)
