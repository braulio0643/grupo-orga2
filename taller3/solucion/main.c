#include <assert.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "checkpoints.h"

int main() {
  /* Acá pueden realizar sus propias pruebas */
  assert(alternate_sum_4(8, 2, 5, 1) == 10);
  printf("%d\n", alternate_sum_4(8, 2, 5, 1));
  printf("%d\n", alternate_sum_4_using_c(8, 2, 5, 1));
  return 0;
}
