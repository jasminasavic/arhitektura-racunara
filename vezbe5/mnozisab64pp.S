.section .text
.globl mnozSab64
mnozSab64:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %eax
	movl 12(%ebp), %ecx
mnozi:
	cmpl $0, %eax
	jne dalje
	cmpl $0, %ecx
	je premesti
dalje:
	addl %eax, 16(%ebp)
	adcl %ecx, 20(%ebp)
	jc prekoracenje
	subl $1, %eax
	sbbl $0, %ecx
	jmp mnozi
premesti:
	movl 24(%ebp), %eax
	movl 16(%ebp), %ecx
	movl %ecx, (%eax)
	movl 28(%ebp), %eax
	movl 20(%ebp), %ecx
	movl %ecx, (%eax)
	jmp kraj
prekoracenje:
	movl $1, %eax
kraj:
	movl %ebp, %esp
	popl %ebp
	ret
