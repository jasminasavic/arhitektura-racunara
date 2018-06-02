.section .data
	a: .quad 0x100000000
	b: .quad 0x10
	c: .quad 0
.section .text
.globl main
main: 
	movl a, %eax
	movl a+4, %ebx
	movl b, %ecx
	movl b+4, %edx
poredi:
	cmpl %ebx, %edx
	ja af
	jne bf
	cmpl %eax, %ecx
	ja af
bf:
	cmpl $0, %edx
	jne mnozib
	cmpl $0, %ecx
	je kraj
mnozib:
	addl %eax, c
	adcl %ebx, c+4
	subl $1, %ecx
	sbbl $0, %edx
	jmp bf
af:
	cmpl $0, %ebx
	jne mnozia
	cmpl $0, %eax
	je kraj
mnozia:
	addl %ecx, c
	adcl %edx, c+4
	subl $1, %eax
	sbbl $0, %ebx
	jmp af
kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
	
	
	
	
	
	
