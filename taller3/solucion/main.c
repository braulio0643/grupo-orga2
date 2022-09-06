#include <assert.h>
#include <ctype.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "checkpoints.h"

int main() {
  /* Acá pueden realizar sus propias pruebas */
  assert(alternate_sum_4(8, 2, 5, 1) == 10);
  assert(alternate_sum_4_using_c(8, 2, 5, 1) == 10);
  assert(alternate_sum_4_simplified(8, 2, 5, 1) == 10);
  assert(alternate_sum_8(8, 2, 5, 1, 8, 9, 8, 1) == 16);
  uint32_t res = 0;
  product_2_f(&res, 10, 5.5);
  printf("%d", res);
  return 0;
}
