#include <stdio.h>
#include <unistd.h>

int main(void) {
	printf("Guten %d Tag %d\n", fork(), fork());
	return 0;
}
