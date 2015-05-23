#include <stdio.h>
int main(void) {
	int a;
	int *aptr;
	char hello[] = "Hello World\n";
	char *hptr;
	a = 10;
	aptr = &a;
	printf("a: %d\n", *aptr);
	hptr = hello + 6;
	printf("%s\n", hptr);
	while (*hptr) {
		printf("%c ", *hptr++);
	}
	printf("\n");
	return 0;
}
