#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <sys/types.h>
#include <sys/wait.h>


void
filtro(int fds[2])
{
	// Creo nuevo pipe
	int fds_nuevo[2];
	int flag_pipe = pipe(fds_nuevo);
	if (flag_pipe < 0) {
		perror("Error en creacion del pipe 0\n");
		_exit(-1);
	}

	// Caso base para salir de la recursividad
	int primo_leido;
	if (read(fds[0], &primo_leido, sizeof(int)) <= 0) {
		_exit(-1);
	}
	printf("primo %d\n", primo_leido);

	int flag_fork = fork();
	if (flag_fork < 0) {
		perror("Error en creacion del proceso\n");
		_exit(-1);
	}

	if (flag_fork == 0) {
		close(fds[0]);
		close(fds_nuevo[1]);
		filtro(fds_nuevo);
		close(fds_nuevo[0]);  // Cierro el canal de lectura

	} else {
		int numero_leido;
		while (read(fds[0], &numero_leido, sizeof(int)) > 0) {
			if (numero_leido % primo_leido != 0) {
				ssize_t escritos = write(fds_nuevo[1],
				                         &numero_leido,
				                         sizeof(int));
				if (escritos == -1) {
					perror("Error al escrbir sobre el "
					       "pipe.\n");
					continue;
				}
			}
		}
		close(fds[0]);
		close(fds_nuevo[0]);
		close(fds_nuevo[1]);
		wait(NULL);
	}

	_exit(0);
}


int
main(int argc, char *argv[])
{
	if (argc != 2) {
		perror("Cantidad de parametros incorrectos.\n");
		_exit(-1);
	}

	int fds[2];  // Creo el primer pipe
	int flag_pipe = pipe(fds);
	if (flag_pipe < 0) {
		perror("Error en creacion del pipe inicial\n");
		_exit(-1);
	}

	int flag_fork = fork();
	if (flag_fork < 0) {
		perror("Error en creacion del proceso\n");
		_exit(-1);
	}

	if (flag_fork == 0) {
		close(fds[1]);  // Cierro el canal de escritura
		filtro(fds);
		// Cierro canal de lectura

	} else {
		int N = (int) atoi(argv[1]);
		for (int i = 2; i < N; i++) {
			ssize_t w = write(fds[1], &i, sizeof(int));
			if (w == -1) {
				perror(" El padre fallo al escribir sobre el "
				       "pipe 1");
				_exit(-1);
			}
		}
		close(fds[0]);
		close(fds[1]);
		wait(NULL);
	}
	_exit(0);
}
