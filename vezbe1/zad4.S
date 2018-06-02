.section .data
.section .text
.globl main
main:
	movl $1, %eax
	movl $1, %ebx
	movl $6, %ecx
provera:
	cmpl $1, %ecx
	je kraj
	cmpl $2, %ecx
	je kraj
f:
	cmpl $1, %ecx
	je kraj
	addl %eax, %ebx
	xchgl %ebx, %eax
	subl $1, %ecx
	jmp f
kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
