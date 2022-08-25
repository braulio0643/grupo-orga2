#ifndef STUDENT_H
#define STUDENT_H

#define NAME_LEN 21
#define NUM_CALIFICATIONS 3

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct student {
  char name[NAME_LEN];                      // 21
  uint32_t dni;                             // 4
  uint8_t califications[NUM_CALIFICATIONS]; // 3
  int16_t concept;                          // 2
} student_t;

typedef struct studentp {
  char name[NAME_LEN];                      // 21
  uint32_t dni;                             // 4
  uint8_t califications[NUM_CALIFICATIONS]; // 3
  int16_t concept;                          // 2
} __attribute__((packed)) studentp_t;

/* A definir en student.c */
void printStudent(student_t *);
void printStudentp(studentp_t *);

#endif
