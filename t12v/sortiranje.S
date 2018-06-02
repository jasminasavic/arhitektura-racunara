#ostvartiti sortiranje niza
.section .data
	niz: .long 1,8,-4,0,-3,5,-44,1,55,4
	vel: .long 10
	
.section .text
.globl main
main:
	movl $0, %esi
	movl $1, %edi
	movl vel, %ebx
	cmpl $1, %ebx
	je kraj
sortiraj:
	cmpl %ebx, %edi
	jne nastavi
	incl %esi
	movl %esi, %edi
	incl %edi
	cmpl %ebx, %edi
	je kraj
nastavi:
	movl niz(,%esi, 4), %eax
	cmpl %eax, niz(, %edi, 4)
	jl zameni
	incl %edi
	jmp sortiraj
zameni:
	movl niz(, %edi, 4), %edx
	movl %eax, niz(, %edi, 4)
	movl %edx, niz(, %esi, 4)
	incl %edi
	jmp sortiraj

kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
