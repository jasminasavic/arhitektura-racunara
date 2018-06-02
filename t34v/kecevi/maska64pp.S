#potprogram koji proverava za 64-bitni broj dobijen preko adrese za svaki 3. bit da li je
#on jednak 1. izbrojati te keceve . zameniti te keceve nulama. vratiti promenjeni broj
.section .text
.globl maska64pp
maska64pp:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %ecx
	pushl %ebx
	pushl %edi
	movl (%ecx), %eax
	addl $4, %ecx
	movl (%ecx), %edi
	movl $4, %edx #maska: 00000000 00000000 00000000 00000100
	movl $0, %ebx
nizi:
	cmpl $0, %edx
	je visi_priprema
	testl %edx, %eax
	jnz primeni_masku1
	shll $3, %edx
	jmp nizi
primeni_masku1:
	notl %edx
	andl %edx, %eax
	notl %edx
	shll $3, %edx
	incl %ebx
	jmp nizi
visi_priprema:
	movl $1, %edx
visi:
	cmpl $0, %edx
	je kraj
	testl %edx, %edi
	jnz primeni_masku2
	shll $3, %edx
	jmp visi
primeni_masku2:
	notl %edx
	andl %edx, %edi
	notl %edx
	shll $3, %edx
	incl %ebx
	jmp visi
	
kraj:
	movl %edi, (%ecx)
	subl $4, %ecx
	movl %eax, (%ecx)
	movl %ebx, %eax
	popl %ebx
	movl %ebp, %esp
	popl %ebp
	ret
