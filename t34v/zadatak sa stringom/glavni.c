#include <stdio.h>

int funkcija(char *);

int main ()
{
	char string[100];
	int br;
	
	scanf("%s", string);
	
	br=funkcija(string);
	
	printf("Vas string: %s.\n Broj odgovarajucih reci: %d.\n", string, br);
	
	
	return 0;
}
