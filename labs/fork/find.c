#define _GNU_SOURCE
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <dirent.h>
#include <fcntl.h>
#include <dirent.h>
#define MAX_PATH 100


int
buscar_nombres(int fd,
               char *busqueda,
               char *(*funcion_comparar)(const char *s1, const char *s2),
               char *path)
{
	DIR *directorio = fdopendir(fd);
	struct dirent *entrada = readdir(directorio);
	if (entrada == NULL) {
		return 0;
	}

	while (entrada) {
		if (strcmp(entrada->d_name, ".") != 0 &&
		    strcmp(entrada->d_name, "..") != 0) {
			if (funcion_comparar(entrada->d_name, busqueda) != 0) {
				printf("%s%s\n", path, entrada->d_name);
			}

			if (entrada->d_type == DT_DIR) {
				char old_path[MAX_PATH];
				strcpy(old_path, path);
				strcat(path, entrada->d_name);
				strcat(path, "/");
				int fddir = dirfd(directorio);
				int fdsubdir = openat(fddir,
				                      entrada->d_name,
				                      O_DIRECTORY);
				if (fdsubdir == -1) {
					perror("Error al abrir el directorio "
					       "con openat.\n");
					_exit(-1);
				}
				buscar_nombres(fdsubdir,
				               busqueda,
				               funcion_comparar,
				               path);
				strcpy(path, old_path);
			}
		}

		entrada = readdir(directorio);
	}
	return 0;
}


int
main(int argc, char *argv[])
{
	char *busqueda = "";
	char *flag = "";

	if (argc == 2) {
		busqueda = argv[1];
	} else if (argc == 3) {
		flag = argv[1];
		busqueda = argv[2];
	} else {
		perror("Cantidad de parametros incorrectos.\n");
		_exit(-1);
	}

	DIR *directorio = opendir(".");
	if (directorio == NULL) {
		perror("Error al abrir el directorio con opendir.\n");
		_exit(-1);
	}

	int fddir = dirfd(directorio);

	char path[MAX_PATH] = "";

	if (strcmp(flag, "-i") != 0) {  // sin flag, tiene en cuenta mayusculas
		buscar_nombres(fddir, busqueda, *strstr, path);
	} else {  // con flag -i, no tiene en cuenta mayusculas y minusculas
		buscar_nombres(fddir, busqueda, *strcasestr, path);
	}


	_exit(0);
}
