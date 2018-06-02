#int maska16pp(short int *, int);
#dobija se niz 16 bitnih brojeva. za svaki clan niza izbrojati koliko jedinica
#ima njegova binarna predstava i izbrojati koliko jedinica ima taj broj, ali negativan, 
#takodje u binarnoj predstavi. ako taj broj iz niza ima vise jedinica nego
#njegova negacija, povecati brojac. ako njegova negacija ima vise
#jedinica, smanjiti brojac, i zameniti taj broj iz niza negacijom
# ako je broj jedinica u tom broju i njegovom negativnom
#jednak, ne raditi nista.

#npr. u nizu se nalazi broj 32. njegova binarna predstava je:
#0000000000100000, on ima samo jednu jedinicu
# sada proverimo za njegovu negaciju, tj. za -32.
#binarna predstava -32 je:
#1111111111100000, -32 ima 11 jedinica
#znaci treba smanjiti brojac i zameniti 32ku sa -32 u nizu.

# kao negativan broj clana niza cemo praviti njegovu komplement 2 predstavu

.section .text
.globl maska16pp
maska16pp:
	pushl %ebp
	movl %esp, %ebp
	subl $4, %esp #broj jedinica u komplementu broja
	pushl %edi #sadrzace adresu niza
	pushl %esi #sadrzace indeks niza
	pushl %ebx #sadrzace broj jedinica u samom broju
	movl 8(%ebp), %edi #adresa niza
	#12(%ebp) sadrzi broj clanova niza
	xorl %eax, %eax #povratna vrednost, stavljamo za pocetak na 0
	xorl %esi, %esi #indeks, stavljamo za pocetak na 0
pripremi_proveru:
	xorl %ebx, %ebx #postavljamo broj jedinica u broju za pocetak na 0
	movl $0, -4(%ebp) #isto i za njegov komplement
pripremi_komplement:
	cmpl 12(%ebp), %esi #kada indeks dostigne broj clanova niza, zavrsavamo program
	je kraj
	movw (%edi, %esi, 2), %dx #u dx cemo napraviti komplement
	movw (%edi, %esi, 2), %cx #u cx cemo ostaviti clan niza kakav jeste
	notw %dx #prvo invertujemo broj
	incw %dx #dodajemo 1 da napravimo komplement 2, tj. njegov negativan broj
jedinice_komplement: #ovde brojimo jedinice komplementa broja
	cmpw $0, %dx #kada shiftujemo broj dovoljno puta u desno, on ce postati 0, to znaci da smo proverili sve cifre komplementa,
		     #i tada mozemo da nastavimo dalje, da poverimo koliko jedinica ima u samom broju
	je jedinice_broj
	testw $1, %dx #maska nam je binarno 1, u nasem slucaju 0000000000000001
	jnz dalje1 #ako nije 0, idemo na labelu dalje1
	shrw $1, %dx #ako je nula, samo radimo right shift da mozemo da poredimo sledecu cifru i idemo dalje
	jmp jedinice_komplement
dalje1: incl -4(%ebp) #ako cifra jeste 1, onda povecavamo ovu promenljivu koja skladisti broj jedinica u komplementu
	shrw $1, %dx #right shift da mozemo da poredimo sledecu cifru
	jmp jedinice_komplement
jedinice_broj: #ovde se broje jedinice u samom broju, radi isto kao kada smo brojali u komplementu, samo koristimo
	       #registar cx jer se tu nalazi broj, i za brojac jedinica koristimo ebx, jer tu skladistimo broj jedinica za sam broj
	cmpw $0, %cx
	je poredi #ovde kada se provere sve cifre, idemo da poredimo broj jedinica u samom broju i broj jedinica u komplementu
	testw $1, %cx
	jnz dalje2
	shrw $1, %cx
	jmp jedinice_broj
dalje2: incl %ebx 
	shrw $1, %cx
	jmp jedinice_broj
poredi:
	cmpl %ebx, -4(%ebp)
	ja izmena #ako je broj jedinica u komplementu veci, potrebno je da uradimo izmene
	je nista #ako su jednaki brojevi jedinica idemo na labelu nista
	incl %eax #ako je broj jedinica u samom broju veci, povecamo povratnu vrednost
	incl %esi #povecamo indeks
	jmp pripremi_proveru ##skacemo na pripremi_proveru jer se tamo resetuju brojaci jedinica za broj i komplement, i krece
				#provera za sledeci broj u nizu
nista: #ovde povecamo indeks, i idemo ispocetka 
	incl %esi
	jmp pripremi_proveru #skacemo na pripremi_proveru jer se tamo resetuju brojaci jedinica za broj i komplement, i krece
				#provera za sledeci broj u nizu
izmena: #ovde menjamo clan u nizu sa njegovim komplementom
	movw (%edi, %esi, 2), %dx #posto smo unistili komplement, moracemo ponovo da ga napravimo tako sto prvo prebacimo broj
					#iz niza u dx
	notw %dx	#invertujemo
	incw %dx 	#dodamo 1 da dobijemo komplement 2
	movw %dx, (%edi, %esi, 2) #prepisemo komplement na njegovo mesto u nizu
	cmpl $0, %eax #ovde moramo videti da li je povratna vrednost 0, ako jeste, necemo je smanjivati da ne vratimo
			#negativnu vrednost, ne znam da li je u pravom zadatku dozvoljeno da povratna vrednost bude
			#negativna, ako jeste, onda ovo ne mora vec je samo smanjimo
	je nastavi
	decl %eax #ako povratna vrednost nije bila nula onda cemo je smanjiti
nastavi: #ako je povratna vrednost bila 0 onda cemo samo povecati indeks i nastaviti
	incl %esi
	jmp pripremi_proveru
kraj:
	popl %ebx
	pushl %esi
	pushl %edi
	movl %ebp, %esp
	popl %ebp
	ret
