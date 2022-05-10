#include "builtin.h"
#include "utils.h"

// returns true if the 'exit' call
// should be performed
//
// (It must not be called from here)
int
exit_shell(char *cmd)
{
	if (strcmp(cmd, "exit") == 0) {
		return 1;
	}
	return 0;
}


// returns true if "chdir" was performed
//  this means that if 'cmd' contains:
// 	1. $ cd directory (change to 'directory')
// 	2. $ cd (change to $HOME)
//  it has to be executed and then return true
//
//  Remember to update the 'prompt' with the
//  	new directory.
//
// Examples:
//  1. cmd = ['c','d', ' ', '/', 'b', 'i', 'n', '\0']
//  2. cmd = ['c','d', '\0']
int
cd(char *cmd)
{
	char *copia = malloc(sizeof(char) * strlen(cmd));
	if (copia == NULL) {
		perror("[ERROR] Fallo al asignar memoria con malloc \n");
	}
	strcpy(copia, cmd);
	char *primer_token = strtok(copia, " ");
	if (strcmp(primer_token, "cd") == 0) {
		char *segundo_token = strtok(NULL, " ");
		if (segundo_token == NULL) {
			if (chdir(getenv("HOME")) == -1) {
				perror("[ERROR] Fallo al cambiar el directorio "
				       "con chdir. \n");
			}
		} else {
			remover_caracter(segundo_token, '/');
			if (chdir(segundo_token) == -1) {
				perror("[ERROR] Fallo al cambiar el directorio "
				       "con chdir. \n");
			}
		}

		free(copia);
		return 1;
	}
	free(copia);
	return 0;
}

// returns true if 'pwd' was invoked
// in the command line
//
// (It has to be executed here and then
// 	return true)
int
pwd(char *cmd)
{
	if (strcmp(cmd, "pwd") == 0) {
		char *directorio_actual = get_current_dir_name();
		printf_debug("%s \n", directorio_actual);
		free(directorio_actual);
		return 1;
	}

	return 0;
}
