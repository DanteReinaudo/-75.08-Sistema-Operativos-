#include "exec.h"

// sets "key" with the key part of "arg"
// and null-terminates it
//
// Example:
//  - KEY=value
//  arg = ['K', 'E', 'Y', '=', 'v', 'a', 'l', 'u', 'e', '\0']
//  key = "KEY"
//
static void
get_environ_key(char *arg, char *key)
{
	int i;
	for (i = 0; arg[i] != '='; i++)
		key[i] = arg[i];

	key[i] = END_STRING;
}

// sets "value" with the value part of "arg"
// and null-terminates it
// "idx" should be the index in "arg" where "=" char
// resides
//
// Example:
//  - KEY=value
//  arg = ['K', 'E', 'Y', '=', 'v', 'a', 'l', 'u', 'e', '\0']
//  value = "value"
//
static void
get_environ_value(char *arg, char *value, int idx)
{
	size_t i, j;
	for (i = (idx + 1), j = 0; i < strlen(arg); i++, j++)
		value[j] = arg[i];

	value[j] = END_STRING;
}

// sets the environment variables received
// in the command line
//
// Hints:
// - use 'block_contains()' to
// 	get the index where the '=' is
// - 'get_environ_*()' can be useful here
static void
set_environ_vars(char **eargv, int eargc)
{
	for (int i = 0; i < eargc; i++) {
		int pos = block_contains(eargv[i], '=');
		char key[MAXARGS];
		char value[MAXARGS];
		get_environ_key(eargv[i], key);
		get_environ_value(eargv[i], value, pos);
		setenv(key, value, 1);
	}
}

// opens the file in which the stdin/stdout/stderr
// flow will be redirected, and returns
// the file descriptor
//
// Find out what permissions it needs.
// Does it have to be closed after the execve(2) call?
//
// Hints:
// - if O_CREAT is used, add S_IWUSR and S_IRUSR
// 	to make it a readable normal file
static int
open_redir_fd(char *file, int flags)
{
	if (flags && O_CREAT) {
		return open(file, flags, S_IWUSR | S_IRUSR);

	} else {
		return open(file, flags, 0);
	}
}


// Funcion en caso de EXEC
void
case_exec_cmd(struct execcmd *e)
{
	if (execvp(e->argv[0], e->argv) == -1) {
		perror("[ERROR] Fallo al ejecutar execvp \n");
		_exit(-1);
	}
}

// Funcion en caso de REDIR
void
case_redir_md(struct execcmd *r)
{
	if (strlen(r->in_file) > 0) {
		int fdin = open_redir_fd(r->in_file, O_RDWR | O_CLOEXEC);
		if (fdin == -1) {
			perror("Error al intentar abrir el archivo de "
			       "entrada\n");
			_exit(-1);
		}
		dup2(fdin, 0);
		close(fdin);
	}

	if (strlen(r->out_file) > 0) {
		int flags = O_RDWR | O_CLOEXEC | O_TRUNC | O_CREAT;
		if (strcmp(r->err_file, "&1") == 0) {
			flags = O_RDWR | O_CLOEXEC | O_APPEND | O_CREAT;
		}
		int fdout = open_redir_fd(r->out_file, flags);
		if (fdout == -1) {
			perror("Error al intentar abrir el archivo de "
			       "salida\n");
			_exit(-1);
		}
		dup2(fdout, 1);
		close(fdout);
	}

	if (strlen(r->err_file) > 0) {
		if (strcmp(r->err_file, "&1") == 0) {
			// codigo para 2>&1;
			dup2(1, 2);
		} else {
			int fderr = open_redir_fd(r->err_file,
			                          O_RDWR | O_CLOEXEC | O_TRUNC |
			                                  O_CREAT);
			if (fderr == -1) {
				perror("Error al intentar abrir el archivo de "
				       "errores\n");
				_exit(-1);
			}
			dup2(fderr, 2);
			close(fderr);
		}
	}
	case_exec_cmd(r);
}


void
case_pipe_cmd(struct pipecmd *p)
{
	int fds[2];
	if (pipe(fds) < 0) {
		perror("[Error] Fallo en la creacion del pipe \n");
		_exit(-1);
	}

	int pid_izq = fork();
	if (pid_izq < 0) {
		perror("[Error] Fallo en la creacion del proceso \n");
		_exit(-1);
	}

	if (pid_izq == 0) {
		close(fds[0]);
		dup2(fds[1], 1);
		close(fds[1]);
		exec_cmd(p->leftcmd);
		_exit(0);
	}

	int pid_der = fork();
	if (pid_der < 0) {
		perror("[Error] Fallo en la creacion del proceso \n");
		_exit(-1);
	}

	if (pid_der == 0) {
		close(fds[1]);
		dup2(fds[0], 0);
		close(fds[0]);
		exec_cmd(p->rightcmd);
		_exit(0);
	}

	close(fds[0]);
	close(fds[1]);
	waitpid(pid_izq, NULL, 0);
	waitpid(pid_der, NULL, 0);
}

// executes a command - does not return
//
// Hint:
// - check how the 'cmd' structs are defined
// 	in types.h
// - casting could be a good option
void
exec_cmd(struct cmd *cmd)
{
	// To be used in the different cases
	struct execcmd *e;
	struct backcmd *b;
	struct execcmd *r;
	struct pipecmd *p;

	switch (cmd->type) {
	case EXEC:
		// spawns a command
		e = (struct execcmd *) cmd;
		set_environ_vars(e->eargv, e->eargc);
		case_exec_cmd(e);
		_exit(-1);
		break;

	case BACK: {
		// runs a command in background
		b = (struct backcmd *) cmd;
		exec_cmd(b->c);
		_exit(-1);
		break;
	}

	case REDIR: {
		// changes the input/output/stderr flow
		//
		// To check if a redirection has to be performed
		// verify if file name's length (in the execcmd struct)
		// is greater than zero
		//
		// Your code here
		r = (struct execcmd *) cmd;
		case_redir_md(r);
		_exit(-1);
		break;
	}

	case PIPE: {
		// pipes two commands
		// Your code here
		p = (struct pipecmd *) cmd;
		case_pipe_cmd(p);
		// free the memory allocated
		// for the pipe tree structure
		// free_command(parsed_pipe);
		break;
	}
	}
}
