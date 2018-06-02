.section .data
	NELEM=8
	niz: .long 2,8,11,25,3,1,30,16
	min: .long 0
	maks: .long 0
.section .text
.globl main
main:
	movl $0, %esi
	movl niz, %eax #pocetni min
	movl niz, %ebx # pocetni max
	incl %esi
	cmpl $NELEM, %esi
	je kraj
poredi:
	cmpl $NELEM, %esi
	je kraj
	cmpl niz(, %esi, 4), %eax
	ja manji
	cmpl niz(, %esi, 4), %ebx
	jl veci
	incl %esi
	jmp poredi
manji:
	movl niz(, %esi, 4), %eax
	incl %esi
	jmp poredi
veci:
	movl niz(, %esi, 4), %ebx
	incl %esi
	jmp poredi
kraj: 
	movl %eax, min
	movl %ebx, maks
	movl $1, %eax
	movl $0, %ebx
	int $0x80
