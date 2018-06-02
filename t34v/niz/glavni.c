// u c programu cemo uneti velicinu niza i clanove niza, pa cemo u potprogram
//poslati pokazivac na niz i velicinu niza
// c program ce ispisati binarne vrednosti  brojeva i pre izvrsavanja potprograma i posle
// ispisuje i povratnu vrednost
//pretpostavicemo da povratna vrednost ne moze biti manja od 0 (zato sto nemam pojma tacno zadatak)




#include <stdio.h>

int maska16pp(short int *, int);

void printbin16(short int x) //stampace 16-bitne brojeve
{
    unsigned int m=0x8000;
    int s=0;
    printf("\n");
    while(m)
    {
        printf("%s%s",m&x ? "1" : "0",++s%8 ? "" : " ");
        m >>= 1;
    }
    
}

int main()
{

    int g=0;
    short int r[10]; // napravila sam da niz moze imati najvise 10 clanova da ne komplikujem mnogo 
    int velicina_niza;
    printf("Unesite velicinu niza (najvise 10): ");
    scanf("%d", &velicina_niza); //unos velicine niza
    int i=0;
    while (i<velicina_niza) 
    {
    	printf("Unesite broj: ");
    	scanf("%hd",&r[i]);
    	i++;
    }
    printf("Brojevi pre izmene: ");
    i=0;
    while (i<velicina_niza)
    {
    	
    	printbin16(r[i]);
    	i++;
    }
    printf("\n");
    g = maska16pp(&r[0], velicina_niza);
    printf("Brojevi posle izmene: ");
    i=0;
    while (i<velicina_niza)
    {
    	
    	printbin16(r[i]);
    	i++;
    }
    printf("\n");
    printf("Povratna vrednost: %u\n.", g);
   }
