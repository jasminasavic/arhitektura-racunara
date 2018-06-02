#include <string.h>

int dec[] = {1000, 500, 100, 50, 10, 5, 1};
char *rom = "MDCLXVI";

unsigned int roman_to_inter(char* str, unsigned int* greska) {
    unsigned int r=0, i=0;
    char *c1,*c2;
    *greska = 0;
    while ((str[i]) && (!*greska)) {
        c1 = index(rom, str[i]);
        if (c1) {
            if (str[i+1]) {
                c2 = index(rom,str[i+1]);
                if (c2) {
                    if (c1<=c2)
                        r += dec[c1-rom];
                    else {
                        r += dec[c2-rom];
                        r -= dec[c1-rom];
                        i++;
                    }
                }
                else *greska = 1;
            }
            else r += dec[c1-rom];
        }
        else *greska = 1;
        i++;
    }
    return r;
}

