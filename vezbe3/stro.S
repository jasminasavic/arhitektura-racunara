.section .data
	s: .ascii "     abcd   \0"
.section .text
.globl main
main:
	movl $0, %edi
	movl $0, %esi
	cmpb $0, s(, %esi, 1)
	je kraj
provera:
	cmpb $' ', s(, %esi, 1)
	jne postavi
	incl %esi
	jmp provera
postavi:
	movb s(, %esi, 1), %bl
	movb %bl, s(, %edi, 1)
	incl %edi
	incl %esi
	cmpb $0, s(, %esi, 1)
	jne postavi
	movb $0, s(, %edi, 1)	
kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
