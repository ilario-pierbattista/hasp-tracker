// [...]
#include "adaboost.h"
#include "mexutils.h"

// [...]

/**
 * Main function
 */
void mexFunction(int outc, mxArray *output[], 
    int inc, const mxArray *input[]) 
{
    // [...]
    bestWeakClassifier = Adaboost::bestWeakClassifier(
        samples, features, values);
    // [...]
}

// [...]