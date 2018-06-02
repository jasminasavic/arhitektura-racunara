#include <stdio.h>

unsigned int maska32pp(unsigned int *);

void printbin32(unsigned int x)
{
    unsigned int m=0x80000000;
    int s=0;
    while(m)
    {
        printf("%s%s",m&x ? "1" : "0",++s%8 ? "" : " ");
        m >>= 1;
    }
}

int main()
{
    unsigned int g=0;
    unsigned int r;

    printf("Unesite broj: ");
    scanf("%x",&r);
    printf("Broj pre izmene: ");
    printbin32(r);
    printf("\n");
    g = maska32pp(&r);
    printf("Broj posle izmene: ");
    printbin32(r);
    printf("\n");
    printf("Povratna vrednost: %u\n.", g);
   }
