#include<stdio.h>
#include<math.h>

#include "utils.h"

int barWidth = 70;

void display_progress(double progress) {
    
    printf("[");
  
    int pos = barWidth * progress;
    for (int i = 0; i < barWidth; ++i) {
        if (i < pos) printf("=");
        else if (i == pos) printf(">");
        else printf(" ");
    }
    
    fflush(stdout);
    printf("] %d%%\r", (int) round(progress * 100.0));

}

void int16ToDouble(int16_t *input, double *output, int length)
{
    int i;
 
    for ( i = 0; i < length; i++ ) {
        output[i] = (double)input[i];
    }
}
 
void doubleToInt16( double *input, int16_t *output, int length )
{
    int i;
 
    for ( i = 0; i < length; i++ ) {
        if ( input[i] > INT16_MAX) {
            input[i] = INT16_MAX;
        } else if ( input[i] < INT16_MIN ) {
            input[i] = INT16_MIN;
        }
        // convert
        output[i] = (int16_t)input[i];
    }
}