//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#include <inttypes.h>
#include "callback.h"
#define MAX_ITER 200
#define MAX_SCORE -1

uint8_t* generateSolution(swiftFuncPtr cb);
int generatePuzzle(const uint8_t *solution, uint8_t *puzzle, int max_iter, int max_score, int target_score);
