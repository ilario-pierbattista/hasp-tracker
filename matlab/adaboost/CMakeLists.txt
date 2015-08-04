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
    NAME evaluate_thresholds
    SRC evaluate_thresholds.cxx
    LINK_TO mexutils adaboost feature geometry
)

matlab_add_mex(
    NAME weak_classify_samples
    SRC weak_classify_samples.cxx
    LINK_TO mexutils
)
