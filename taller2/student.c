#include "student.h"
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

void printStudent(student_t *stud)
{
    /* Imprime por consola una estructura de tipo student_t
      char name[NAME_LEN];                      // 21
  uint32_t dni;                             // 4
  uint8_t califications[NUM_CALIFICATIONS]; // 3
  int16_t concept;
    */
    printf("Print student\n");
    printf("Nombre: \t%s\n",stud->name);
    printf("DNI: \t%d\n",stud->dni);
    printf("Nota 1:\t%d\nNota 2:\t%d\nNota 3:\t%d\n",stud->califications[0],stud->califications[1],stud->califications[2]);
    printf("Concepto:\t%d\n",stud->concept);
    printf("------------------------\n");
}

void printStudentp(studentp_t *stud)
{
    /* Imprime por consola una estructura de tipo studentp_t
     */
    printf("Print student\n");
    printf("Nombre: \t%s\n",stud->name);
    printf("DNI: \t%d\n",stud->dni);
    printf("Nota 1:\t%d\nNota 2:\t%d\nNota 3:\t%d\n",stud->califications[0],stud->califications[1],stud->califications[2]);
    printf("Concepto:\t%d\n",stud->concept);
    printf("------------------------\n");
}
