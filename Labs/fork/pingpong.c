#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>

int
main()
{
	int fds1[2];  // primer pipe
	int fds2[2];  // segundo pipe

	srandom(time(NULL));

	// Creo primer pipe y verifico que se cree correctamente
	int r1 = pipe(fds1);
	if (r1 < 0) {
		perror("Error en creacion del pipe 1");
		_exit(-1);
	}

	// Creo segundo pipe y verifico que se cree correctamente
	int r2 = pipe(fds2);
	if (r2 < 0) {
		perror("Error en creacion del pipe 2");
		_exit(-1);
	}

	printf("Hola, soy PID <%d> \n", getpid());
	printf("	- el primer pipe me devuelve: [%d,%d] \n",
	       fds1[0],
	       fds1[1]);
	printf("	- el segundo pipe me devuelve: [%d,%d] \n",
	       fds2[0],
	       fds2[1]);

	// Creo el proceso hijo y verifico que se cree correctamente
	int i = fork();
	if (i < 0) {
		perror("Error en creacion del proceso");
		_exit(-1);
	}


	if (i == 0) {
		// Aca esta el proceso hijo, lo pongo a dormir 2 segundos para que no se pisen los printf
		sleep(2);
		printf("Donde fork me devuelve %d \n", i);
		printf("	- getpid me devuelve: <%d> \n",
		       getpid());  // Devuelve pid
		printf("	- getppid me devuelve: <%d> \n",
		       getppid());  // Devuelve la pid del padre

		close(fds1[1]);  // El hijo no escribe sobre pipe 1
		close(fds2[0]);  // El hijo no va a leer sobre pipe 2

		// El hijo lee el pipe 1
		int recv = 0;
		if (read(fds1[0], &recv, sizeof(recv)) < 0) {
			perror("El hijo fallo al leer sobre pipe 1");
			_exit(-1);
		}
		printf("	- recibo valor <%d> via fd = %d \n", recv, fds1[0]);

		// El hijo escribe sobre el pipe 2
		if (write(fds2[1], &recv, sizeof(recv)) < 0) {
			perror(" El hijo fallo al escribir sobre el pipe 2");
			_exit(-1);
		}
		printf("	- reenvio valor via fd = %d y termino\n", fds2[1]);

		close(fds1[0]);  // Al terminar cierro los archivos
		close(fds2[1]);

	} else {
		// Aca genero el numero random, lo divido para que no sea tan
		// grande y que el printf quede mas estetico
		int msg = random() % 180;
		printf("Donde fork me devuelve %d \n", i);
		printf("	- getpid me devuelve: <%d> \n", getpid());
		printf("	- getppid me devuelve: <%d> \n", getppid());
		printf("	- random me devuelve: <%d> \n", msg);
		printf("	- envio valor <%d> en fd = %d \n", msg, fds1[1]);


		// El padre no va a leer el pipe 1 ni escribir sobre el pipe 2, cierro estos archivos
		close(fds1[0]);
		close(fds2[1]);

		// escribo el mensaje sobre el pipe 1
		if (write(fds1[1], &msg, sizeof(msg)) < 0) {
			perror(" El padre fallo al escribir sobre el pipe 1");
			_exit(-1);
		}
		// recibo la respuesta del hijo sobre el pipe 2
		int recv2 = 0;
		if (read(fds2[0], &recv2, sizeof(recv2)) < 0) {
			perror(" El padre fallo al leer sobre el pipe 2");
			_exit(-1);
		}

		printf("Hola, de nuevo PID <%d> \n", getpid());
		printf("	- recibi el valor <%d> via fd = %d \n",
		       recv2,
		       fds2[0]);
		close(fds1[1]);  // cierro los archivos
		close(fds2[0]);
	}

	_exit(0);
}
