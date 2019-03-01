#treba porediti k-ti i k+drugi clan niza 1. ukoliko su ta dva clana ista, upisati 0 u niz2
#ukoliko je k<k+2 upisati 1, ukoliko je k>k+2, upisati -1.
#ako niz1 ima n clanova, niz2 ce imati n-2 clana 
.section .data
	niz1: .long 1,2,4,2,1,4,7,8,1,6,1,8
	vel_niza1 = ( . - niz1)/4 #posto je velicina u bajtima, moramo podeliti sa 4
	vel_niza2 = vel_niza1 - 2 #posto pretposlednji i poslednji nemamo sa cime da poredimo, 2. niz mora imati 2 elementa manje
	niz2: .fill vel_niza2, 4, 0 #inciijalizujemo 2. niz na sve nule
.section .text
.globl main
main:
	movl $0, %esi #pocinjemo poredjenje od 0. clana niza sa
	movl $2, %edi #2. clanom niza
poredi: 
	cmpl $vel_niza2, %esi #uslov za izlazak iz petlje je kada indeks k-tog clana postane jednak velicini 2. niza
	je kraj
	movl niz1(, %esi, 4), %eax #poredimo k-ti i k+2-ti clan
	cmpl %eax, niz1(, %edi, 4)
	ja dodaj #ako je k+2-ti clan veci skacemo na dodaj
	jb oduzmi # ako je manji, skacemo na oduzmi
	incl %esi #ukoliko su isti, posto je niz inicijalizovan na 0, 0 i treba da ostane, samo uvecamo indekse i idemo dalje
	incl %edi
	jmp poredi
dodaj:
	incl niz2(, %esi, 4) #posto je niz vec inicijalizovan na 0, dovoljno je samo da uvecamo trenutni clan za 1
	incl %edi
	incl %esi
	jmp poredi
oduzmi:
	decl niz2(, %esi, 4) #slicno, ovde je dovoljno samo da oduzmemo 1
	incl %edi
	incl %esi
	jmp poredi
kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
