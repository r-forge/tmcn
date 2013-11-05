
#include "distance.h"

extern "C" {
    void CWrapper_distance(char **file_name, char **word)
    {
        distance(*file_name, *word);
    }
}

