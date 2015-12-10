// [...]
#include "adaboost.h"
#include "mexutils.h"

// [...]

void mexFunction(int outc, mxArray *output[], 
    int inc, const mxArray *input[]) 
{
    // [...]
    bestWeakClassifier = Adaboost::bestWeakClassifier(
        samples, features, values);
    // [...]
}

// [...]