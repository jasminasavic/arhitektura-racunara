.section .data
	NELEM=10
	niz: .long 1,2,3,4,5,6,7,8,9,10
	poc: .long 2
	kra: .long 5
	suma: .long 0
.section .text
.globl main

main:
	movl poc, %esi
	movl $0, %eax
	incl kra
petlja: 
	addl niz(, %esi, 4), %eax
	incl %esi
	cmpl kra, %esi
	jl petlja
kraj:
	movl %eax, suma
	movl $1, %eax
	movl $0, %ebx
	int $0x80
