.section .data
.section .text
.globl main
main:
	movl $5, %eax
	movl $6, %ebx
	movl $0, %ecx
mnozenje:
	cmpl $0, %ebx
	je kraj
	cmpl $0, %eax
	je kraj
	addl %eax, %ecx
	subl $1, %ebx
	jmp mnozenje
kraj: 
	movl $1, %eax
	movl $0, %ebx
	int $0x80
