.section .data
.section .text
.globl main
main:
	movl $5, %eax
	movl $0, %ebx
uporedi:
	cmpl $0, %eax
	je kraj
	addl %eax, %ebx
	subl $1, %eax
	jmp uporedi
kraj: 
	movl $1, %eax
	movl $0, %ebx
	int $0x80
