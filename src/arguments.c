#include <stdio.h>

int main(int argc, char* argv[]) {
	/* Schleife ueber alle Argumente */
	for (int i = 0; i < argc; i++) {
		/* Ausgabe zeilenweise */
		printf("argv[%d] = %s\n", i, argv[i]);
	}
	return 0;
}
