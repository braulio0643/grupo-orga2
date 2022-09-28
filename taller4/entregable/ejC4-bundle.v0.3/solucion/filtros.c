#include <assert.h>
#include <string.h>

#include "filtros.h"

void fir_init(FIR_t *filtro) {
  memset(filtro->buffer, 0, sizeof(filtro->buffer));
}

size_t fir_filter(FIR_t *filtro, int16_t *in, unsigned length, int16_t *out) {
  int32_t acc;   // acumulador para MACs
  int16_t *in_p; // puntero a las muestras de entrada

  memcpy(&filtro->buffer[filtro->length - 1], in, length * sizeof(int16_t));

  // aplicar el filtro
  int16_t *coeff_p;

  for (unsigned n = 0; n < length; n++) {
    coeff_p = filtro->coefs;
    in_p = &filtro->buffer[filtro->length - 1 + n];
    acc = 0;
    for (int k = 0; k < filtro->length; k++) {
      acc += (int32_t)(*coeff_p++) * (int32_t)(*(in_p--));
    }

    // saturar el resultado
    if (acc > 0x3fffffff) {
      acc = 0x3fffffff;
    } else if (acc < -0x40000000) {
      acc = -0x40000000;
    }
    // convertir de Q30 a Q15
    out[n] = (int16_t)(acc >> 15);
  }

  memmove(&filtro->buffer[0], &filtro->buffer[length],
          (filtro->length - 1) * sizeof(int16_t));

  return length;
}
