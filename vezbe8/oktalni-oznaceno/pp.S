#int oct_str_to_inter(char* str, unsigned int* greska);
.section .text
.globl oct_str_to_inter
oct_str_to_inter:
	pushl %ebp
	movl %esp, %ebp
	pushl %ebx
	pushl %edi
	pushl %esi
	movl 8(%ebp), %edi #adresa pocetka stringa
	movl %edi, %esi #cuvamo jos jednom pocetak
	#na 12(%ebp) je greska
	xorl %eax, %eax #rezultat
	xorl %ebx, %ebx #ponistavamo ebx zbog kasnijih operacija
	xorl %edx, %edx #ponistavamo edx zbog kasnijih operacija
	movl $8, %ecx
znak: #moramo proveriti da li uneseni string sadrzi predznak broja za konverziju, ukoliko ne sadrzi znak + ili -, smatra se da je 
      #broj pozitivan
	movb (%edi), %bl
	cmpb $'-', %bl #proverava da li je broj negativan
	je negativan #ako ima znak minus pripremamo se za konverziju
	cmpb $'+', %bl #proverava da li je predznak pozitivan, ako jeste samo pomerimo mesto za jedan unapred 
	jne provera #ukoliko ne postoji ikakav znak, smatramo da je broj pozitivan, idemo na konverziju
	incl %edi
provera:
	movb (%edi), %bl
	andb %bl, %bl #proveravamo da li smo dosli do kraja stringa
	jz kraj_dec #ako jesmo, idemo na labelu kraj_dec gde cemo dalje proveriti da li je broj negativan ili pozitivan ponovo,
		    #da znamo da li da ga mnozimo sa -1 ili ne
	cmpb $'0', %bl
	jb greska_znak
	cmpb $'7', %bl	#isto samo proveravanje da li je znak u opsegu
	ja greska_znak
	subb $'0', %bl #pretvaramo iz znakovnog u interni oblik
	mull %ecx #mnozimo broj sa osnovom sistema iz kojeg pretvaramo
	cmpl $0, %edx #proveravamo da li je doslo do prekoracenja
	jne prekoracenje
	addl %ebx, %eax #sabiramo rezultat i znak stringa
	jc prekoracenje #proveravamo da li je doslo do prekoracenja
	incl %edi #pomeramo se za jedno mesto
	jmp provera
negativan: #samo se pomerimo za jedno mesto unapred
	incl %edi
	jmp provera
prekoracenje: #ako je doslo do prekoracenja, upisujemo kod greske 2 u adresu gde se nalazi greska
	movl 12(%ebp), %ebx
	movl $2, (%ebx)
	jmp kraj
kraj_dec: #kada dodje do kraja konverzije, provericemo da li je na prvom mestu znak negacije ili ne
	movb (%esi), %bl
	cmpb $'-', %bl
	jne izuzetak #ako nije, proveravamo onaj jedan izuzetak, gde je uneseni broj ako je negativan
	#nije van opsega, ali ako je pozitivan, van opsega je, tj. umesto 20000000000(8)=2^31 bice prepoznat kao 
	# -2147483648=-2^31=-20000000000(8), jer je opseg od -2^31 do (2^31)-1, a broj -20000000000(8) nije van opsega.
	# ovo treba racunati kao gresku. dakle mi smo uneli pozitivan 20000000000(8), a nakon konverzije dobijemo -2147483648
	# sto je nemoguce, treba proveriti da li je to bas taj izuzetak
	movl $-1, %ecx #ako jeste negativan, moramo pomnoziti broj sa -1
	mull %ecx
	jmp nastavi
izuzetak:
	cmpl $0, %eax #ako uneti broj u stringu nije negativan (sto smo zakljucili po tome sto se na pocetku ne nalazi '-', 
	# da vidimo da li je doslo do izuzetka, moramo da proverimo da li je broj koji smo dobili nakon konverzije negativan
	jl prekoracenje #ako broj dobijen konverzijom jeste negativan, doslo je do prekoracenja
nastavi: #ukoliko nije doslo do prekoracenja, samo upisujemo 0 u kod greske, sto znaci da je sve bilo uspesno
	movl 12(%ebp), %ebx
	movl $0, (%ebx)
	cmpl %esi, %edi
	jne kraj
greska_znak: #kod greske za neispravan uneti znak je 1
	movl 12(%ebp), %ebx
	movl $1, (%ebx)
kraj:
	popl %esi
	popl %edi
	popl %ebx
	movl %ebp, %esp
	popl %ebp
	ret
