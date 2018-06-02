#include <stdio.h>

//povratna vrednost je fibonacijev broj
int fibonaci(int n);

int main()
{
    int f, n=15;
    f = fibonaci(n);
    printf("fibonaci(%d)=%d\n", n, f);
}
