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
  printf("%d\n", alternate_sum_8(10,2,4,3,6,1,3,7));
  uint32_t res=0;
  product_2_f(&res, 10, 5.5);
  printf("%d\n", res);
  return 0;
}
