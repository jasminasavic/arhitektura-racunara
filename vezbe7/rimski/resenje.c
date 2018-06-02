#include <string.h>

int dec[] = {1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1};
char *rom[] = {"M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"};

int inter_to_roman(unsigned int broj, char *str, int duzina) {
    int i;
    for (i=0; i<13; i++)
        while (broj >= dec[i]) {
            if (strlen(rom[i]) > duzina-1)
                return 1;
            strcat(str,rom[i]);
            broj -= dec[i];
            duzina -= strlen(rom[i]);
        }
    return 0;
}

