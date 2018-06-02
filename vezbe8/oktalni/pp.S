#unsigned int oct_str_to_inter(char* str, unsigned int* greska);
.section .text
.globl oct_str_to_inter
oct_str_to_inter:
	pushl %ebp
	movl %esp, %ebp
	subl $4, %esp
	pushl %ebx
	pushl %edi
	pushl %esi
	movl 8(%ebp), %edi #pocetak niza
	movl %edi, -4(%ebp) #cuvamo ga jos jednom u lokalnu promenljivu
	movl 12(%ebp), %esi #adresa gde treba da upisemo gresku
	xorl %eax, %eax #rezultat
	xorl %ebx, %ebx #ponistavamo jer nam treba u potpunosti prazan registar kada ga budemo koristili da tu smestimo
	#broj i kada budemo sabirali, da nam se ne bi sabralo nesto od znacajnijih cifara posto cemo koristiti samo bl
	xorl %edx, %edx # ponistavamo i edx jer ce u njega ici znacajnije cifre broja ukoliko bude veci nego 32-bitni
	#ako ne dodje do prekoracenja u njemu ce ostati 0
	movl $0, (%esi) # za pocetak pretpostavimo da nema greske, pa upisujemo 0
	movl $8, %ecx # baza sistema iz kojeg pretvaramo broj u dekadni sistem
provera:
	movb (%edi), %bl #postavljamo trenutni znak stringa u bl
	andb %bl, %bl #ukoliko je on jednak '\0' to znaci da smo ili dosli do kraja konverzije ili je string prazan
	jz kraj_dec
	cmpb $'0', %bl #prvo moramo proveriti da li nam znakovi u opsegu kojem pripadaju cifre oktalnog sistema
		       # ako ne pripadaju, doslo je do greske
	jb greska_znak
	cmpb $'7', %bl
	ja greska_znak
	subb $'0', %bl #ako znak prodje proveru, znaci da je neki od cifara od 0 do 7 i mozemo da ga konvertujemo
		       #prvo oduzimamo '0' od njega da bismo dobili njegovu internu predstavu od znakovne
	mull %ecx # mnozimo nas trenutni rezultat sa bazom sistema
	cmpl $0, %edx #ukoliko smo dobili da postoji prekoracenje preko 32-bitnog broja, greska je prekoracenje
	jne prekoracenje
	addl %ebx, %eax # dodajemo nas broj na rezultat
	jc prekoracenje
	incl %edi #povecavamo broj elemenata i nastavljamo dalje
	jmp provera
prekoracenje:
	movl $2, (%esi)
	jmp kraj
kraj_dec: #ukoliko smo dobili da je nas znak jednak '\0',  proverimo da li je edi na pocetku stringa, ako jeste, to znaci
	  #da je string prazan, pa upisujemo u gresku broj 1; ako nije na pocetku stringa to znaci da smo zavrsili konverziju
	cmpl -4(%ebp), %edi
	jne kraj
greska_znak:
	movl $1, (%esi)
kraj:
	popl %esi
	popl %edi
	popl %ebx
	movl %ebp, %esp
	popl %ebp
	ret
