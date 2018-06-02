.section .data
.section .text
.globl main
main:
	movl $5, %eax
	movl $6, %ebx
	movl $0, %ecx
provera:
	cmpl $0, %ebx
	je kraj
	cmpl $0, %eax
	je kraj
	cmpl %ebx, %eax
	ja b
	jmp a
b:
	cmpl $0, %ebx
	je kraj
	addl %eax, %ecx
	subl $1, %ebx
	jmp b
a:
	cmpl $0, %eax
	je kraj
	addl %ebx, %ecx
	subl $1, %eax
	jmp a
kraj: 
	movl $1, %eax
	movl $0, %ebx
	int $0x80
