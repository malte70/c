#include <stdio.h>

int main() {
	printf("Length of common data types:\n");
	printf("char\t%d B\n", sizeof(char));
	printf("int\t%d B\n", sizeof(int));
	printf("long\t%d B\n", sizeof(long));
	printf("float\t%d B\n", sizeof(float));
	printf("double\t%d B\n", sizeof(double));
	
	return 0;
}
