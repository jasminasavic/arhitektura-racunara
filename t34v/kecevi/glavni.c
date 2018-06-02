#include <stdio.h>

unsigned int maska64pp(unsigned long long *);

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
    unsigned long long r;

    printf("Unesite broj: ");
    scanf("%llx",&r);
    printf("Broj pre izmene: ");
    printbin64(r);
    printf("\n");
    g = maska64pp(&r);
    printf("Broj posle izmene: ");
    printbin64(r);
    printf("\n");
    printf("Broj keceva na svakom trecem bitu: %u\n.", g);
   }
