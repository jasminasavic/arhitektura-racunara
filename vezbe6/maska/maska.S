.section .text
.globl maska
maska:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %ecx
	movl 12(%ebp), %eax
	pushl %edi
	
provera:
	movl $0, %edi
	cmpl $31, %ecx
	ja neispravno
	cmpl $1, %eax
	ja neispravno
	movl $1, %edx #maska
pomeraj:
	cmpl %edi, %ecx
	je proveri1
	shll $1, %edx
	incl %edi
	jmp pomeraj
proveri1:
	cmpl $0, %eax
	je promeni
	movl %edx, %eax
	jmp kraj
promeni:	
	notl %edx
	movl %edx, %eax
	jmp kraj
neispravno:
	movl $0, %eax
kraj:
	popl %edi
	movl %ebp, %esp
	popl %ebp
	ret
