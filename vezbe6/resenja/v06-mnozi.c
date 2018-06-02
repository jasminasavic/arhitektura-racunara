#include <stdio.h>

// potprogram za množenje pomoću šiftovanja
int mnozi_bin(unsigned long long a, unsigned long long b,
              unsigned long long *r);

int main() {
    int g;
    unsigned long long a, b, r;

    a = 136ULL;
    b = 23455ULL;

    g = mnozi_bin(a, b, &r);

    printf("Rezultat:%llu\n",r);
    printf("Greska  :%d\n",g);
    printf("Tacno   :%llu\n",a*b);

    return 0;
}

