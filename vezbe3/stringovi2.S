.section .data
	s: .ascii "     abcd   \0"
.section .text
.globl main
main:
	jmp poc_s
poc_s:
	cmpb $' ', s
	je postavi
	jmp kraj
postavi:
	movl $s, %eax
	cmpb $0, 1(%eax)
	jne pomeri
	jmp kraj
	
pomeri:
	movb 1(%eax), %bl
	movb %bl, (%eax)
	incl %eax
	cmpb $0, 1(%eax)
	je na_nulu
	jmp pomeri
na_nulu:
	movl $0, (%eax)
	jmp poc_s
kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
