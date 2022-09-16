#ifndef UTILS_H_
#define UTILS_H_

#include<stdint.h>

void display_progress(double progress);
void int16ToDouble(int16_t *input, double *output, int length);
void doubleToInt16(double *input, int16_t *output, int length);

#endif //UTILS_H_
