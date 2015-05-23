#include <stdio.h>
#include <unistd.h>

int main(void) {
	printf("Guten Tag %d\n", fork());
	return 0;
}
