#include <stdio.h>

unsigned int RUNPP_REG_ERR = 0;

int from101to111(int* v);

void printbin32( int x) {
    unsigned  int m=0x80000000, s=0;
    while(m) {
        printf("%s%s",m&x ? "1" : "0",++s%8 ? "" : " ");
        m >>= 1;
    }
    printf(" (%d)",x);
}

int main() {
    int v;
    int g=0;

    printf("Unesite vrednost: ");
    scanf("%u",&v);
    printf("\nVrednost pre  : ");
    printbin32(v);
    v = from101to111(&v);
    printf("\nVrednost posle: ");
    printbin32(v);
    printf("\n");

    if (RUNPP_REG_ERR) return RUNPP_REG_ERR+128;
    else return g;
}

