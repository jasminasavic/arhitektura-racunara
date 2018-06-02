#include <stdio.h>
#include <string.h>

unsigned int inter_to_str(int broj, char* str, unsigned int duz, unsigned int baza);

//pomoćni potprogram za testiranje
//prvi parametar je vrednost koja se konvertuje
//drugi parametar je koliko znakova će biti na raspolaganju za konverziju
//treći je baza u koju se konvertuje
int test(int b, unsigned int d, unsigned int bz) {
    char *s = strdup("****************************************");
    int g;
    printf("Ulaz  : inter_to_oct_str(%d,s,%d,%d)\n",b,d,bz);
    g = inter_to_str(b,s,d,bz);
    printf("Greška: %d\n",g);
    if (g == 0) {
        printf("String: %s\n",s);
        if (b>=0)
            printf("Tačno : ");
        else {
            printf("Tačno : -");
            b = -b;
        }
        switch (bz) {
            case  8: printf("%o",b); break;
            case 10: printf("%u",b); break;
            case 16: printf("%X",b); break;
            default: printf("(printf ne podržava bazu)");
        }
    }
    //provera da li je memorija iza dozvoljene netaknuta
    for (g=d;g<40;g++)
        if (s[g] != '*') {
            printf("\n\nMenjana memorija iza dozvoljene!!!");
            break;
        }
    printf("\n\n");
}

int main() {
    //ok
    test(12345678,7,16);
    test(12345678,9,10);
    test(12345678,9,8);
    test(-12345678,8,16);
    test(-12345678,10,10);
    test(-12345678,10,8);
    //greška
    test(12345678,6,16);
    test(12345678,8,10);
    test(12345678,8,8);
    test(-12345678,7,16);
    test(-12345678,9,10);
    test(-12345678,9,8);
}

