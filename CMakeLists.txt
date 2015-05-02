cmake_minimum_required(VERSION 3.2)
project(hasp_tracker)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE_FILES
    matlab/haar/haarHorizontalEdge.m
    matlab/haar/haarHorizontalLinear.m
    matlab/haar/haarVerticalEdge.m
    matlab/haar/haarVerticalLinear.m
    matlab/hasp/mex/haar-like.o
    matlab/hasp/mex/haar_like.cc
    matlab/hasp/mex/haar_like.mexa64
    matlab/hasp/mex/haar_like.o
    matlab/hasp/generateWindow.m
    matlab/hasp/localMinima.m
    matlab/hasp/picker.fig
    matlab/hasp/picker.m
    matlab/include/general.h
    matlab/include/haar-like.cc
    matlab/include/haar-like.h
    matlab/io/getDatasetPath.m
    matlab/io/getFramesPath.m
    matlab/io/readImageData.m
    matlab/procedures/showIntegralVideoFromFrames.m
    matlab/procedures/showVerticalHaarVideo.m
    matlab/procedures/showVideoFromFrames.m
    matlab/utilities/mex/prove/mex_haar_edges.cc
    matlab/utilities/mex/prove/vertical_haar_edge.cc
    matlab/utilities/mex/mex_haar_features.cc
    matlab/utilities/mex/mex_haar_features.mexa64
    matlab/utilities/mex/mex_integral_image.cc
    matlab/utilities/mex/mex_integral_image.mexa64
    matlab/utilities/getMinimum.m
    matlab/utilities/integralImage.m
    matlab/initEnvironment.m
    notes/computer-vision.html
    notes/hasp-tracker.html
    notes/machine-learning.html
    notes/style.css
    resources/matlab_code/code_haar_features/images/kio_tower.jpg
    resources/matlab_code/code_haar_features/images/window.jpg
    resources/matlab_code/code_haar_features/mex/mex_haar_features.cc
    resources/matlab_code/code_haar_features/mex/mex_haar_features.mexa64
    resources/matlab_code/code_haar_features/mex/mex_img2II.cc
    resources/matlab_code/code_haar_features/mex/mex_img2II.mexa64
    resources/matlab_code/code_haar_features/prg_haar_features.m
    resources/matlab_code/code_haar_features/prg_setup.m
    resources/matlab_code/code_haar_features/README.txt
    scripts/dataset_downloader.py
    journal.txt
    README.md)

add_executable(hasp_tracker ${SOURCE_FILES})