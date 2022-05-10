#ifndef UTILS_H
#define UTILS_H

#include "defs.h"

char *split_line(char *buf, char splitter);

int block_contains(char *buf, char c);

int printf_debug(char *format, ...);
int fprintf_debug(FILE *file, char *format, ...);

void remover_caracter(char *arg, char caracter);

#endif  // UTILS_H
