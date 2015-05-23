#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>

int main(void) {
	struct stat buf;
	stat("Makefile", &buf);
	printf("Groesse: %d\n", (int)buf.st_size);
	if (buf.st_mode & S_IRUSR) {
		printf("Der Besitzer darf die Datei lesen.\n");
	}
	if (!(buf.st_mode & S_IRWXO)) {
		printf("Andere haben keine Berechtigungen.\n");
	}
	return 0;
}
