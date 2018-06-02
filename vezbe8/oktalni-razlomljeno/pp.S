#unsigned int oct_str_float_to_inter(char* str, unsigned int* greska);


#string izgleda npr: "0.34\0"

#jedina greska koja se moze javiti je da je unet neispravan znak. ovde nema greske izlaska van opsega, jer mozemo samo
#izgubiti na preciznosti
.section .text
.globl oct_str_float_to_inter
oct_str_float_to_inter:
	pushl %ebp
	movl %esp, %ebp
	subl $4, %esp
	subl $8, %esp
	subl $12, %esp
	pushl %edi
	pushl %esi
	pushl %ebx
	movl 8(%ebp), %edi #pocetak stringa
	movl %edi, -12(%esp) #cuvamo ga jos jednom
	addl $1, -12(%esp) #povecavamo poziciju za jedan, da stoji na '.'
	#na 12(%ebp) je greska
	xorl %eax, %eax #rezultat
	xorl %ebx, %ebx #ponistavamo ebx i edx zbog operacija
	xorl %edx, %edx
	movl $8, %ecx #baza sistema iz kojeg konvertujemo
	movl $0x5F5E100, -4(%ebp) #10^8 u dekadnom sistemu
	movl $0, -8(%ebp) #ovo je lokalna promenljiva koja ce nam privremeno trebati pri konverziji za cuvanje rezultata
pronadji_kraj:
	movb (%edi), %bl
	andb %bl, %bl #posto konverzija ide sa kraja, trazimo kraj stringa
	jz konverzija
	incl %edi 
	jmp pronadji_kraj
konverzija:
	xorl %ebx, %ebx #ponistavamo ebx
	decl %edi #vracamo se na cifru iza null karaktera
	cmpl %edi, -12(%esp) #proveravamo da li smo dosli do 1. pozicije u strngu, ako jesmo, to znaci da smo dosli do
	#decimalne tacke i da smo zavrsili konverziju
	je uspesno
	movb (%edi), %bl 
	cmpb $'0', %bl
	jb greska
	cmpb $'7', %bl  #proverava se da li uneti znak pripada bazi
	ja greska
	subb $'0', %bl #konverzija znaka iz znakovnog u internu cifru
	movl %eax, -8(%ebp) #privremeno kopiramo rezultat u pomocnu promenljivu kako bismo mogli da vrsimo operacije
	#sa unetim znakom, a da bismo to uradili moramo ga premestiti iz ebx-a u eax, a ne zelimo da izgubimo ono sto se nalazi u eax-u
	movl %ebx, %eax #premestamo cifru dobijenu konverzijom iz ebx u eax
	mull -4(%ebp) #mnozimo je sa 10^8 kako bismo mogli da skaliramo rezultat
	movl %eax, %ebx #sada skaliranu cifru vracamo nazad u ebx
	movl -8(%ebp), %eax #vracamo rezultat u eax
	addl %ebx, %eax #sabiramo skalirani rezultat sa rezultatom
	xorl %edx, %edx #ponistavamo edx da nam ne ostane nista u njemu posto on ucestvuje u divl operaciji
	divl %ecx #delimo nas rezultat iz eax-a sa bazom sistema
	jmp konverzija #nastavljamo konverziju
greska: #kod greske za neispravan uneti znak je 1
	movl 12(%ebp), %ebx
	movl $1, (%ebx)
	jmp kraj
uspesno:
	movl 12(%ebp), %ebx
	movl $0, (%ebx)
kraj:	
	popl %ebx
	popl %esi
	popl %edi
	movl %ebp, %esp
	popl %ebp
	ret
