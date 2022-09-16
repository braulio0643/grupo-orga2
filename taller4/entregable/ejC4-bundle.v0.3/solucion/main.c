#include <assert.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <argp.h>

#include "filtros.h"
#include "utils.h"

#include "wav.h"

#define NUM_CHANNELS 2

#define LEFT 0
#define RIGHT 1

#define BLOCK_SIZE 256

void wav_setup(WavFile* readfile, WavFile* writefile);

const char *argp_program_version = "oppenheim 1.0";
static char doc[] =  "oppenheim -- Our friend oppenheim help us filtering wavs.\n\n\
Filter the WAV file SRC with a FIR filter and generates an output WAV file";

static char args_doc[] = "SRC";

static struct argp_option options[] = {
  {"output", 'o', "DST", 0, "output file", 0},
  {"simd", 's', 0, 0, "use SIMD implementation", 0},
  {"filter", 'f', "FILTER", 0, "filter to use. Defaults to 'lowpass'", 0},
  { 0 }
};

struct arguments
{
  char *args[1];                /* arg1 & arg2 */
  char *output_file;
  int simd;
  char *filter;
};

static error_t
parse_opt (int key, char *arg, struct argp_state *state)
{
  /* Get the input argument from argp_parse, which we
     know is a pointer to our arguments structure. */
  struct arguments *arguments = state->input;

  switch (key)
    {
    case 'o':
      arguments->output_file = arg;
      break;

    case 's':
      arguments->simd = 1;
      break;
    
    case 'f':
      arguments->filter = arg;
      break;

    case ARGP_KEY_ARG:
      if (state->arg_num >= 2)
        /* Too many arguments. */
        argp_usage (state);

      arguments->args[state->arg_num] = arg;

      break;

    case ARGP_KEY_END:
      if (state->arg_num < 1)
        /* Not enough arguments. */
        argp_usage (state);
      break;

    default:
      return ARGP_ERR_UNKNOWN;
    }
  return 0;
}

static struct argp argp = {options, parse_opt, args_doc, doc, 0, 0, 0};

int main (int argc, char *argv[]) {
    assert(BLOCK_SIZE <= MAX_INPUT_BLOCK_LEN && "Tamaño de bloque excedido");
    
    struct arguments arguments;
    arguments.output_file = "output.wav";
    arguments.simd = 0;
    arguments.filter = "lowpass";
    argp_parse (&argp, argc, argv, 0, 0, &arguments);

    WavFile *readfile = wav_open(arguments.args[0], WAV_OPEN_READ);
    WavFile *writefile = wav_open(arguments.output_file, WAV_OPEN_WRITE);

    wav_setup(readfile, writefile);

    int16_t *COEFS = COEFS_LOWPASS;
    int FILTER_TAP_NUM = FILTER_TAP_NUM_LOWPASS;

    if (strcmp("deepspace", arguments.filter) == 0){
        COEFS = COEFS_DEEPSPACE;
        FILTER_TAP_NUM = FILTER_TAP_NUM_DEEPSPACE;
    }else if(strcmp("highpass", arguments.filter) == 0){
        COEFS = COEFS_HIGHPASS;
        FILTER_TAP_NUM = FILTER_TAP_NUM_HIGHPASS;
    }else if(strcmp("bandpass", arguments.filter) == 0){
        COEFS = COEFS_BANDPASS;
        FILTER_TAP_NUM = FILTER_TAP_NUM_BANDPASS;
    }else if(strcmp("impulse", arguments.filter) == 0){
        COEFS = COEFS_IMPULSE;
        FILTER_TAP_NUM = FILTER_TAP_NUM_IMPULSE;
    }else if(strcmp("lowpass", arguments.filter) == 0){
        COEFS = COEFS_LOWPASS;
        FILTER_TAP_NUM = FILTER_TAP_NUM_LOWPASS;
    }else{
        printf("Unknown filter: %s\n", arguments.filter);
        exit(EXIT_FAILURE);
    }

    
    printf("Input: %s\n", arguments.args[0]);
    printf("Output: %s\n", arguments.output_file);
    printf("Filtro: %s\n", arguments.filter);
    printf("Implementation: %s\n\n", arguments.simd? "SIMD": "C");

    FIR_t filtro_l;
    FIR_t filtro_r;
    filtro_l.coefs = COEFS;
    filtro_l.length = FILTER_TAP_NUM;

    filtro_r.coefs = COEFS;
    filtro_r.length = FILTER_TAP_NUM;

    fir_init(&filtro_l);
    fir_init(&filtro_r);

    int samplesProcessed = 0;
    int samplesRead;
    int16_t (*rbuffer)[BLOCK_SIZE] = (int16_t(*)[BLOCK_SIZE]) malloc(NUM_CHANNELS * BLOCK_SIZE * sizeof(int16_t));
    int16_t (*wbuffer)[BLOCK_SIZE] = (int16_t(*)[BLOCK_SIZE]) malloc(NUM_CHANNELS * BLOCK_SIZE * sizeof(int16_t));

    size_t totalNumSamples = wav_get_length(readfile);

    size_t (*filter)(FIR_t*, int16_t *, unsigned , int16_t *);
    filter = arguments.simd? fir_filter_simd: fir_filter;

    while ( (samplesRead = wav_read(readfile, (void*) rbuffer, BLOCK_SIZE, SPLIT)) != 0) {

        if (samplesRead % 8 == 0){
            filter(&filtro_l, rbuffer[LEFT], samplesRead, wbuffer[LEFT]);
            filter(&filtro_r, rbuffer[RIGHT], samplesRead, wbuffer[RIGHT]);
        
            int samplesWritten = wav_write(writefile, (void*) wbuffer, BLOCK_SIZE, SPLIT);

            assert(samplesWritten > 0 && "No se pudo escribir al archivo!");

            samplesProcessed += samplesRead;
            display_progress(((samplesProcessed * 1.0)/totalNumSamples));
        }
    }

    printf("\n");
    free(rbuffer);
    free(wbuffer);
    wav_close(readfile);
    wav_close(writefile);
    return 0;

}

void wav_setup(WavFile* readfile, WavFile* writefile){
    int sampleRate = wav_get_sample_rate(readfile);
    size_t totalNumSamples = wav_get_length(readfile);
    int channels = wav_get_num_channels(readfile);

    char *format;
    switch (wav_get_format(readfile))
    {
        case WAV_FORMAT_PCM:        format="PCM"; break;
        case WAV_FORMAT_IEEE_FLOAT: format="IEEE FLOAT"; break;
        case WAV_FORMAT_ALAW:       format="A-LAW"; break;
        case WAV_FORMAT_MULAW:      format="u-LAW"; break;
        case WAV_FORMAT_EXTENSIBLE: format="EXT"; break;
        default: break;
    }

    printf("WAV %s %d Hz - %ld samples\n", format, sampleRate, totalNumSamples);
    
    wav_set_format(writefile, wav_get_format(readfile));
    wav_set_sample_size(writefile, wav_get_sample_size(readfile));
    wav_set_num_channels(writefile,wav_get_num_channels(readfile));
    wav_set_sample_rate(writefile,wav_get_sample_rate(readfile));
}