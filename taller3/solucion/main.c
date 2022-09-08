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
  uint32_t x1 = 1;
  uint32_t x2 = 2;
  uint32_t x3 = 3;
  uint32_t x4 = 4;
  uint32_t x5 = 5;
  uint32_t x6 = 6;
  uint32_t x7 = 7;
  uint32_t x8 = 8;
  uint32_t x9 = 9;
  float f1 = 1.5;
  float f2 = 2.5;
  float f3 = 3.5;
  float f4 = 4.5;
  float f5 = 5.5;
  float f6 = 6.5;
  float f7 = 7.5;
  float f8 = 8.5;
  float f9 = 9.5;
  double destination = 0;
  product_9_f(&destination, x1, f1, x2, f2, x3, f3, x4, f4, x5, f5, x6, f6, x7, f7, x8, f8, x9, f9);
  printf("%f\n", destination);
}
