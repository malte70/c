#include <stdio.h>

int main() {
	printf("Length of common data types:\n");
	printf("char\t%ld B\n", sizeof(char));
	printf("int\t%ld B\n", sizeof(int));
	printf("long\t%ld B\n", sizeof(long));
	printf("float\t%ld B\n", sizeof(float));
	printf("double\t%ld B\n", sizeof(double));
	
	return 0;
}
