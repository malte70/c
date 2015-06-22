#include <stdio.h>
#include <string.h>

int main() {
	char organisation[20] = "FH Dortmund";
	char string2[20];
	
	printf("organisation = \"%s\"\n", organisation);
	printf("string2      = \"%s\"\n", string2);
	
	printf("\nRunning: strcpy(string2, organisation)\n");
	strcpy(string2, organisation);
	printf("organisation = \"%s\"\n", organisation);
	printf("string2      = \"%s\"\n", string2);
	
	printf("\nRunning: strlen(string2)\n");
	printf("strlen(string2) = %ld\n", strlen(string2));
	
	printf("\nRunning: strcmp(string2, organisation)\n");
	printf("strcmp(string2, organisation) = %d\n", strcmp(string2, organisation));
	
	printf("\nRunning: strcat(string2, organisation)\n");
	strcat(string2, organisation);
	printf("organisation = \"%s\"\n", organisation);
	printf("string2      = \"%s\"\n", string2);
	
	printf("\nRunning: strcmp(string2, organisation)\n");
	printf("strcmp(string2, organisation) = %d\n", strcmp(string2, organisation));
	return 0;
}
