matlab_add_mex(NAME get_features SRC get_features.cxx)
matlab_add_mex(NAME best_weak_classifier best_weak_classifier.cxx LINK_TO adaboost mexutils)
matlab_add_mex(NAME calculate_features calculate_features.cxx LINK_TO adaboost mexutils)