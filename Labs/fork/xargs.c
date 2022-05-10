#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <sys/types.h>
#include <sys/wait.h>

#ifndef NARGS
#define NARGS 4
#endif


int
main(int argc, char *argv[])
{
	if (argc < 2) {
		perror("Cantidad de parametros incorrectos.\n");
		_exit(-1);
	}
	size_t bytes = 0;
	for (int i = 1; i < argc; ++i) {
		bytes = bytes + sizeof(argv[i]);
	}

	char *comando = malloc(bytes + argc - 2);
	for (int i = 1; i < argc; ++i) {
		strcat(comando, argv[i]);
		if (i != argc - 1) {
			strcat(comando, " ");
		}
	}

	size_t numero_bytes;
	size_t bytes_leidos;
	char *linea;
	numero_bytes = 0;
	bytes_leidos = 0;
	linea = NULL;

	while (bytes_leidos != -1) {
		char *argumentos[] = {};
		argumentos[0] = comando;
		int c = 1;
		for (int i = 0; i < NARGS; ++i) {
			bytes_leidos = getline(&linea, &numero_bytes, stdin);
			if (bytes_leidos != -1) {
				int salto = strcspn(linea, "\n");
				linea[salto] = 0;
				char *copia = malloc(numero_bytes - 1);
				if (copia == NULL) {
					perror("Error al pedir memoria con "
					       "malloc \n");
					_exit(-1);
				}
				strncpy(copia, linea, numero_bytes - 1);
				argumentos[c] = copia;
				c++;
			}
		}
		argumentos[c] = NULL;

		int pid_hijo = fork();
		if (pid_hijo < 0) {
			perror("Error en creacion del proceso");
			_exit(-1);
		}

		if (pid_hijo == 0) {
			int flag_execvp = execvp(comando, argumentos);
			if (flag_execvp == -1) {
				perror("Error al ejecutar execvp \n");
				_exit(-1);
			}
			for (int i = 1; i < c; ++i) {
				free(argumentos[i]);
			}
		}

		else {
			wait(NULL);
			for (int i = 1; i < c; ++i) {
				free(argumentos[i]);
			}
		}
	}
	free(comando);
	free(linea);
	_exit(0);
}
