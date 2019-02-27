.section .data
.section .text
.globl main
main:
	movl $1, %eax#rezultat
	movl $1, %ebx 
	movl $6, %ecx
provera:
	cmpl $2, %ecx
	jbe kraj
	addl %eax, %ebx
	xchgl %ebx, %eax
	subl $1, %ecx
	jmp provera
kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
