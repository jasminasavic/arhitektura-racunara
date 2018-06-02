#include <stdio.h>

unsigned int maska64pp(unsigned long long *, unsigned long long *);

void printbin64(unsigned long long x)
{
    unsigned long long m=0x8000000000000000ULL;
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
    unsigned long long r, k;

    printf("Unesite broj 1: ");
    scanf("%llx",&r);
    printf("Unesite broj 2: ");
    scanf("%llx",&k);
    printf("Broj 1 pre izmene: ");
    printbin64(r);
    printf("Broj 2 pre izmene: ");
    printbin64(k);
    printf("\n");
    g = maska64pp(&r, &k);
    printf("Broj posle 1 izmene: ");
    printbin64(r);
    printf("Broj posle 2 izmene: ");
    printbin64(k);
    printf("\n");
    printf("Povratna vrednost: %u\n.", g);
   }
