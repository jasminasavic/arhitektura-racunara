#include <stdio.h>

//Mnozenje preko sabiranja u dvostrukoj preciznosti
//Ako se desi prekoracenje, gresku vratiti kao povratne vrednosti
int mnozSab64(long long a, long long b, long long *c);

int main()
{
    long long a = 0x123456789;
    long long b = 0x1111111110;
    long long c = 0;
    int g;
    g = mnozSab64(a,b,&c);
    if (g == 0)
        printf("Rezultat je: %llx\n", c);
    else
        printf("Došlo je do greške!\n");
    return g;
}
