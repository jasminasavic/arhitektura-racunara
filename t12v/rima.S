#korisnik unosi dva stringa. proveriti da li se oni rimuju. rimuju se ako su im poslednja tri slova jednaka.
#proveriti jos i da li su poslednje reci u ta dva stringa jednake.
#ostvariti unos i ispis preko sistemskih poziva.
.section .data
	poruka: .ascii "Unesite dva stringa:\n\0"
	por= . - poruka
	rim: .ascii "Recenice se rimuju.\n\0"
	r= . - rim
	nerim: .ascii "Recenice se ne rimuju.\n\0"
	n= . - nerim
	iste: .ascii "Reci su iste.\n\0"
	i= . - iste
	string_max=51
	string1: .fill string_max, 1, 0
	string2: .fill string_max, 1, 0
	
	d1: .long 0 #promenljiva ce cuvati duzinu 1. stringa
	d2: .long 0 #promenljiva cuva duzinu 2. stringa
	
.section .text
.globl main
main:
	movl $4, %eax
	movl $1, %ebx
	leal poruka, %ecx
	movl $por, %edx
	int $0x80
	
	movl $3, %eax
	movl $0, %ebx
	leal string1, %ecx
	movl $string_max, %edx
	int $0x80
	
	movl %eax, d1
	
	movl $3, %eax
	movl $0, %ebx
	leal string2, %ecx
	movl $string_max, %edx
	int $0x80
	
	movl %eax, d2
	
	subl $2, d1 #umanjicemo oba broja za 2 (-1 zbog "\0" i -1 zbog indeksnog adresiranja)
	subl $2, d2
	
	movl d1, %esi #registri esi i edi ce cuvati indeks poslednjeg karaktera kako bismo mogli da proveravamo sa kraja
	movl d2, %edi
	
	subl $3, %esi #za rimovanje proveravamo samo poslednja 3 karaktera pa cemo u eax da smestimo indeks
	movl %esi, %eax # karaktera tri mesta iza da ne proveravamo dalje bez potrebe
	addl $3, %esi
	
poslednja_rec: #ovaj deo ce da proverava odgovarajuca 3 poslednja karaktera da li su isti i razliciti od karaktera " "
		#jer ako je razmak medju ta poslednja 3, automatski se reci ne rimuju
	cmpl %esi, %eax 
	je rimuju_se #uslov za izlaz iz petlje je kada ustanovimo da su sva 3 karaktera ista a to se desava kada dodjemo do toga
	movb string1(, %esi, 1), %bl #da smo proverili sva 3 karaktera
	cmpb $32, %bl
	je nista #ako je karakter razmak, ne rimuju se i ne vracamo se u petlju vec ispisujemo poruku
	cmpb %bl, string2(, %edi, 1)
	jne nista #ako karakteri nisu isti, ne rimuju se reci i ne vracamo se u petlju vec ispisujemo poruku
	decl %esi
	decl %edi
	jmp poslednja_rec
nista:
	movl $4, %eax
	movl $1, %ebx
	leal nerim, %ecx
	movl $n, %edx
	int $0x80
	jmp kraj
rimuju_se:
	movl $4, %eax
	movl $1, %ebx
	leal rim, %ecx
	movl $r, %edx
	int $0x80
	
	jmp provera #posto smo ustanovili da se poslednje reci rimuju, sad treba da proverimo da li su i reci iste
	
provera:
	movb string1(, %esi, 1), %bl #nastavljamo poredjenje tamo gde smo stali
	cmpb %bl, string2(, %edi, 1)
	je razmak #ukoliko su karakteri isti, provericemo da li su oni znak " " sto znaci da smo dosli do kraja reci
	jne kraj #ako nisu karakteri isti, prekidamo petlju, idemo na kraj
razmak:
	cmpb $32, %bl
	je iste_reci #ako jesu karakteri jesu razmak, znaci da smo dosli do kraja reci i ispisujemo da su reci iste
	decl %esi #a ako nisu razmak, smanjujemo indekse da proveravamo dalje dok ne dodjemo do razmaka
	decl %edi
	jmp provera
iste_reci:
	movl $4, %eax
	movl $1, %ebx
	leal iste, %ecx
	movl $i, %edx
	int $0x80
kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
