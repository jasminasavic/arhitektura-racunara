.section .data
	a: .quad 0x100000000
	b: .quad 0x10
	c: .quad 0
.section .text
.globl main
main:
	movl a, %eax
	movl a+4, %ebx

mnozenje:
	cmpl $0, b+4
	jne mnozi
	cmpl $0, b
	je kraj
mnozi:	addl %eax, c
	adcl %ebx, c+4
	subl $1, b
	sbbl $0, b+4
	jmp mnozenje

kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
