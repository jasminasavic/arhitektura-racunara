#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <sys/ioctl.h>
#include <unistd.h>

// dimenzije ekrana
#define WIDTH 80
#define HEIGHT 25
#define SCRSIZE (WIDTH*HEIGHT)
const int scrwidth = WIDTH;
const int scrheight = HEIGHT;
const int scrsize = SCRSIZE;

// deklaracije funkcija koje treba realizovati
void clearscr();
int gotoxy(int x, int y);
void printchr(int chr);
void printstr(char* str);
void printnum(int num);

// memorija za emulirani ekran
unsigned char screen[SCRSIZE];


/************************************************
          Simulacija iscrtavanja ekrana
*************************************************/

// iscrtavanje ekrana
void draw_screen(int signum) {
    int i,j,h,w;
    struct winsize ws;
    unsigned char c;

    // odredi dimenzije terminala
    ioctl(STDOUT_FILENO, TIOCGWINSZ, &ws);
    w = (ws.ws_col < WIDTH+3) ? ws.ws_col - 2 : WIDTH;
    h = (ws.ws_row < HEIGHT+3) ? ws.ws_row - 3 : HEIGHT;

    // iscrtaj simulirani ekran, koliko može da stane na terminal
    system("clear");
    printf("╔"); for (i=0; i<w; i++) printf("═"); printf("╗");
    printf("\n");
    for (j=0; j<h; j++) {
        printf("║");
        for (i=0; i<w; i++) {
            c = screen[j*WIDTH+i];
            printf("%c", (c > 31 && c < 127) ? c : '.');
        }
        if (w==WIDTH) printf("║");
        printf("\n");
    }
    if (h==HEIGHT) {
    printf("╚"); for (i=0; i<w; i++) printf("═"); printf("╝");
        printf("\n");
    }
}

// inicijalizacija tajmera
void timer_setup() {
    static struct sigaction sa;
    static struct itimerval timer;

    // instaliraj draw_screen kao obrađivač SIGALRM signala
    memset (&sa, 0, sizeof (sa));
    sa.sa_handler = &draw_screen;
    sigaction (SIGALRM, &sa, NULL);

    // podesi tajmer da se aktivira nakon 50ms
    timer.it_value.tv_sec = 0;
    timer.it_value.tv_usec = 50000;
    // i svakih 50ms posle toga
    timer.it_interval.tv_sec = 0;
    timer.it_interval.tv_usec = 50000;

    // pokretanje tajmera
    setitimer (ITIMER_REAL, &timer, NULL);
}

// pauza u milisekundama
void wait(int msec) {
    struct timespec req, rem;
    int res = 1;
    req.tv_sec = msec / 1000;
    req.tv_nsec = (msec % 1000) * 1000000L;
    while (res) {
        res = nanosleep(&req, &rem);
        req.tv_sec = rem.tv_sec;
        req.tv_nsec = rem.tv_nsec;
    }
}

/************************************************
         Testiranje ispravnosti funkcija
*************************************************/

// testiranje brisanja ekrana i ispisa znakova, bez kontrolnih znakova
void test1() {
    int i;
    clearscr();
    for (i=32;i<128;i++)
        printchr(i);
}

// testiranje brisanja ekrana i ispisa stringa, bez kontrolnih znakova
void test2() {
    int i;
    clearscr();
    for (i=0;i<80;i++)
        printstr("Ana voli Milovana!!! ");
}

// testiranje ispisa stringa sa kontrolnim znacima
void test3() {
    int i,x=1,dx=1;
    clearscr();
    printstr("1\t2\t3\t4\t5\t6\t7\t8\t");
    while(1) {
        for (i=0; i<x; i++) printchr('*');
        printstr(" \r");
        x = x + dx;
        if ((x<1)||(x>scrwidth-3)) dx = -dx;
        wait(30);
    }
}

// testiranje skrolovanja ekrana
void test4() {
    int x=0,dx=1,i;
    clearscr();
    while(1) {
        printchr('\n');
        for (i=0; i<x; i++) printchr(' ');
        printchr('*'); 
        x = x + dx;
        if ((x<1)||(x>scrwidth-3)) dx = -dx;
        wait(25);
    }
}

// testiranje gotoxy i ispisa brojeva
void test5() {
    int x=7,y=3,dx=1,dy=1,xx=1,yy=1,tim;
    char buff[100];
    clearscr();
    while(1) {
        gotoxy(xx,yy); printchr(' ');
        gotoxy(x,y); printchr('*');
        xx = x; yy = y;
        x = x + dx;
        y = y + dy;
        if ((x<1)||(x>scrwidth-3)) dx = -dx;
        if ((y<1)||(y>scrheight-2)) dy = -dy;
        gotoxy(30,0);
        printstr("X="); printnum(x);
        printstr(" Y="); printnum(y);
        printstr(" DX="); printnum(dx);
        printstr(" DY="); printnum(dy);
        printstr("      ");
        wait(50);
    }
}

// zmija
int test6() {
    const slen = 15;
    int x[slen+1],y[slen+1];
    int smerx[4] = {1,0,-1,0};
    int smery[4] = {0,1,0,-1};
    int i,smer=0,korak=0;
    for (i=0; i<=slen; i++) {
        x[i] = 5;
        y[i] = 5;
    }
    clearscr();
    while(1) {
        // ispis
        gotoxy(x[0],y[0]);
        printchr(' ');
        for (i=1; i<slen; i++) {
            gotoxy(x[i],y[i]);
            printchr('*');
        }
        gotoxy(x[slen],y[slen]);
        printchr('@');
        gotoxy(scrwidth/2-4,0);
        printstr("smer: ");
        printnum(smer);
        // pomeranje koordinata
        for (i=0; i<slen; i++) {
            x[i] = x[i+1];
            y[i] = y[i+1];
        }
        // nova koordinata
        x[slen] = x[slen] + smerx[smer];
        y[slen] = y[slen] + smery[smer];
        // novi smer
        if (++korak > 5) {
            if ((x[slen] > 2) && (x[slen] < scrwidth-2) && (y[slen] > 2) && (y[slen] < scrheight-2))
                if ((rand() % 10) > 7) smer = (smer + 1) % 4;
            korak = 0;
        }
        if ((x[slen] <= 2) || (x[slen] >= scrwidth-2) || (y[slen] <= 2) || (y[slen] >= scrheight-2)) {
            smer = (smer + 1) % 4;
            korak = 0;
        }
        wait(50);
    }
}

int main () {
    char c;
    printf("Odaberite test (izlaz je sa Ctrl+C):\n");
    printf("1 - brisanje ekrana i ispis znakova\n");
    printf("2 - brisanje ekrana i ispis stringa\n");
    printf("3 - ispis stringa sa kontrolnim znacima\n");
    printf("4 - skrolovanje ekrana\n");
    printf("5 - gotoxy i ispis brojeva\n");
    printf("6 - zmija\n");
    scanf("%c",&c);
    timer_setup();
    switch (c) {
        case '1' : test1(); break;
        case '2' : test2(); break;
        case '3' : test3(); break;
        case '4' : test4(); break;
        case '5' : test5(); break;
        case '6' : test6(); break;
    }
    sleep(1);
}

