/*

FIR filter designed with
http://t-filter.appspot.com

sampling frequency: 44100 Hz

fixed point precision: 16 bits

* 0 Hz - 3000 Hz
  gain = 3
  desired ripple = 5 dB
  actual ripple = n/a

* 3500 Hz - 22000 Hz
  gain = 0
  desired attenuation = -40 dB
  actual attenuation = n/a

*/
#include<stdint.h>

int FILTER_TAP_NUM_LOWPASS = 96;

int16_t COEFS_LOWPASS[] = {
  -77,
  -277,
  -182,
  -294,
  -340,
  -403,
  -448,
  -481,
  -494,
  -485,
  -450,
  -391,
  -309,
  -207,
  -92,
  29,
  147,
  254,
  340,
  397,
  419,
  400,
  341,
  244,
  114,
  -40,
  -205,
  -367,
  -511,
  -622,
  -683,
  -683,
  -613,
  -467,
  -246,
  47,
  400,
  800,
  1227,
  1662,
  2081,
  2461,
  2782,
  3025,
  3177,
  3228,
  3177,
  3025,
  2782,
  2461,
  2081,
  1662,
  1227,
  800,
  400,
  47,
  -246,
  -467,
  -613,
  -683,
  -683,
  -622,
  -511,
  -367,
  -205,
  -40,
  114,
  244,
  341,
  400,
  419,
  397,
  340,
  254,
  147,
  29,
  -92,
  -207,
  -309,
  -391,
  -450,
  -485,
  -494,
  -481,
  -448,
  -403,
  -340,
  -294,
  -182,
  -277,
  -77,
  0,
  0,
  0,
  0,
  0
};
