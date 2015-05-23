#include <stdio.h>
#include <unistd.h>

int main(void) {
	printf("Guten %d\n", fork());
	printf("Tag %d\n", fork());
	return 0;
}
