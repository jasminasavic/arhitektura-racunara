#include <stdio.h>

int funkcija(char *, char *);

int main ()
{
	char string1[100], string2[100];
	int br;
	
	scanf("%s%s", string1, string2);
	
	br=funkcija(string1, string2);
	
	if(br==1)
	printf("Vas string1: %s.\n", string1);
	else
	printf("Vas string2: %s.\n", string2);
	
	
	
	return 0;
}
