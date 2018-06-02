#naci koliko presecnih tacaka imaju niz1 i niz2.
.section .data
	pres: .ascii "Ima preseka.\n\0"
	p= . - pres
	npres: .ascii "Nema preseka.\n\0"
	n= . - npres
	
	niz1: .long 1, 65, 3, 45, -1
	vel1=  . - niz1
	
	niz2: .long 65, 5, 3, 6
	vel2= . - niz2
	
	brojac: .long 0
	
	
.section .text
.globl main
main:
	movl $0, %esi
	movl $0, %edi
	movl $vel1/4, %eax
	movl $vel2/4, %ebx
	cmpl %eax, %ebx
trazi:
	cmpl %ebx, %edi
	je promena
	cmpl %eax, %esi
	je poruka
	movl niz1(, %esi, 4), %ecx
	cmpl %ecx, niz2(, %edi, 4)
	je povecaj
	incl %edi
	jmp trazi
povecaj:
	incl brojac
	incl %edi
	jmp trazi
promena:
	movl $0, %edi
	incl %esi
	jmp trazi
	
poruka:
	cmpl $0, brojac
	ja presek
	
	movl $4, %eax
	movl $1, %ebx
	leal npres, %ecx
	movl $n, %edx
	int $0x80
	
	jmp kraj
	
presek:
	movl $4, %eax
	movl $1, %ebx
	leal pres, %ecx
	movl $p, %edx
	int $0x80
	
kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
	
	
	
	
	
	
	
	
