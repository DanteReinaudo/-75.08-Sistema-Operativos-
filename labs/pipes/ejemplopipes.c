#include <fcntl.h>
#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>

void cat(int writefd) {
	dup2(writefd,1);
	close(writefd);
    execlp("cat", "cat", "./file.txt", NULL);
}

void grep(int readfd,int writefd) {
	dup2(readfd,0);
	close(readfd);
	dup2(writefd,1);
	close(writefd);
    execlp("grep", "grep", "hola", NULL);
}

void wc(int readfd) {
	dup2(readfd,0);
	close(readfd);
    execlp("wc", "wc", "-l", NULL);
}

void pipe_exec(int readfd) {
    int fds[2];
    pipe(fds);

    int pid_izq = fork();

    if (pid_izq == 0) {
		close(fds[0]);
        grep(readfd,fds[1]);
        _exit(0);
    }

    int pid_der = fork();

    if (pid_der == 0) {
		close(fds[1]);
		close(readfd);
        wc(fds[0]);
        _exit(0);
    }
    
    close(fds[0]);
    close(fds[1]);
    close(readfd);
    
    waitpid(pid_izq,NULL,0);
    waitpid(pid_der,NULL,0);
}

int main(int argc, char* argv[]) {
  int fds[2];
  pipe(fds);

  int pid_izq = fork();

  if (pid_izq == 0) {
	  close(fds[0]);
      cat(fds[1]);
      _exit(0);
  }

  int pid_der = fork();
  
  if (pid_der == 0) {
	  close(fds[1]);
      pipe_exec(fds[0]);
      _exit(0);
  }
  close(fds[0]);
  close(fds[1]);
  waitpid(pid_izq,NULL,0);
  waitpid(pid_der,NULL,0);
}

 
