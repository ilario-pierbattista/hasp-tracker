//
// Created by ilario on 03/08/15.
//

#ifndef HASP_TRACKER_STRUCTURE_MAPPING_H
#define HASP_TRACKER_STRUCTURE_MAPPING_H

/*
 * Mappatura dei campi della struttura del classificatore
 * forte in matlab.
 * Guardare lo script io/decodeStrongClassifiers.m
 */
#define STRONG_CLASSIFIER_SAMPLES_SIZE "samplesSize"
#define STRONG_CLASSIFIER_FLOOR_VALUE "floorValue"
#define STRONG_CLASSIFIER_SCALE_FACTOR "scaleFactor"
#define STRONG_CLASSIFIER_INNER_OFFSET "innerOffset"
#define STRONG_CLASSIFIER_WEAK_CLASSIFIERS "weakClassifiers"

/*
 * Mappatura dei campi della struttura del classificatore
 * debole in matlab
 * Guardare script io/decodeWeakClassifier.m
 */
#define WEAK_CLASSIFIER_FEATURE "feature"
#define WEAK_CLASSIFIER_POLARITY "polarity"
#define WEAK_CLASSIFIER_THRESHOLD "threshold"
#define FEATURE_TLP "topleft"
#define FEATURE_DIM "dimension"
#define FEATURE_TYPE "featureType"


#endif //HASP_TRACKER_STRUCTURE_MAPPING_H
