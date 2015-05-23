#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <stdlib.h>

int main(void) {
	pid_t pid;
	int status;
	
	printf("Programm gestartet\n");
	
	pid = fork();
	
	if (pid < 0) {
		perror("fork error");
		exit(1);
	} else if (pid == 0) {
		sleep(1);
		printf("Kindprozess mit PID %d\n", getpid());
		exit(100);
	}
	sleep(2);

	printf("Elternprozess mit PID %d\n", getpid());
	printf("Kindprozess hat PID %d \n",pid);
	pid = wait(&status);

	if (pid > 0) {
		printf("Kindprozess PID %d ",pid);
		if (WIFEXITED(status)) {
			printf("mit Exit-Status %d ", status >> 8);
		}
		printf("terminiert\n");
	}
	
	return 0;
}
