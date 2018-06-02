.section .data
	s: .ascii "     abcd   \0"
.section .text
.globl main

main:
	movl $s, %eax
kraj_s:
	cmpb $0, (%eax)
	je razmaci
	incl %eax
	jmp kraj_s
razmaci:
	cmpb $' ', -1(%eax)
	jne izbaci
	decl %eax
	jmp razmaci
izbaci:
	movb $0, (%eax)
kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
