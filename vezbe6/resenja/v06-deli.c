#include <stdio.h>

// potprogram za deljenje pomoću šiftovanja
int deli_bin(unsigned long long a, unsigned long long b,
              unsigned long long *r);

int main() {
    int g;
    unsigned long long a, b, r;

    a = 136ULL;
    b = 23455ULL;

    g = deli_bin(a, b, &r);

    printf("Rezultat:%llu\n",r);
    printf("Greska  :%d\n",g);
    if (b!=0)
        printf("Tacno   :%llu\n",a*b);
    else
        printf("Tacno   :Greska\n");

    return 0;
}

