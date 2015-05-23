#include <stdio.h>
#include <time.h>

struct Datum {
	int Tag;
	int Monat;
	int Jahr;
};

int main() {
	time_t t;
	struct tm tm;
	
	struct Datum eindatum; /* Eine Strukturvariable vom Typ struct Datum */
	struct Datum *einptr; /* Ein Zeiger auf eine derartige Variable */
	einptr = &eindatum; /* einptr zeigt auf ein datum */
	eindatum.Tag = 6; /* Zuweisung des Feldes Tag mit dem Wertes 6 */
	einptr->Monat = 12; /* Zuweisung des Feldes Monat mit dem Wert 12
						   ueber den Zeiger einptr */
	(*einptr).Jahr = 2004; /* Zuweisung ueber Dereferenzierungsoperator */
	
	printf("Datum: %d-%d-%d\n", einptr->Jahr, einptr->Monat, einptr->Tag);
	
	t = time(NULL);
	tm = *localtime(&t);
	einptr->Jahr  = tm.tm_year + 1900;
	einptr->Monat = tm.tm_mon + 1;
	einptr->Tag   = tm.tm_mday;
	
	printf("Datum: %d-%02d-%02d\n", einptr->Jahr, einptr->Monat, einptr->Tag);

	return 0;
}
