/*

FIR filter designed with
http://t-filter.appspot.com

sampling frequency: 44100 Hz

fixed point precision: 16 bits

* 0 Hz - 3000 Hz
  gain = 0
  desired attenuation = -40 dB
  actual attenuation = n/a

* 3500 Hz - 22050 Hz
  gain = 1
  desired ripple = 5 dB
  actual ripple = n/a

*/

#include<stdint.h>

int FILTER_TAP_NUM_HIGHPASS = 88;

int16_t COEFS_HIGHPASS[] = {
  2403,
  -2082,
  -1072,
  -346,
  129,
  389,
  477,
  438,
  313,
  134,
  -59,
  -223,
  -343,
  -384,
  -351,
  -243,
  -81,
  104,
  276,
  399,
  440,
  384,
  236,
  18,
  -227,
  -448,
  -593,
  -619,
  -505,
  -256,
  93,
  478,
  819,
  1030,
  1035,
  784,
  259,
  -510,
  -1453,
  -2470,
  -3439,
  -4238,
  -4764,
  27821,
  -4764,
  -4238,
  -3439,
  -2470,
  -1453,
  -510,
  259,
  784,
  1035,
  1030,
  819,
  478,
  93,
  -256,
  -505,
  -619,
  -593,
  -448,
  -227,
  18,
  236,
  384,
  440,
  399,
  276,
  104,
  -81,
  -243,
  -351,
  -384,
  -343,
  -223,
  -59,
  134,
  313,
  438,
  477,
  389,
  129,
  -346,
  -1072,
  -2082,
  2403,
  0
};
