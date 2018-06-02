.section .text
.globl fibonaci
fibonaci:
	pushl %ebp
	movl %esp, %ebp
	
	
provera:
	movl $1, %eax
	movl $1, %ecx
	movl 8(%ebp), %edx
	cmpl $1, 8(%ebp)
	je kraj
	cmpl $2,8(%ebp)
	je kraj
f:
	cmpl $2, %edx
	je kraj
	addl %eax, %ecx
	xchgl %ecx, %eax
	subl $1, %edx
	jmp f
kraj:
	movl %ebp, %esp
	popl %ebp
	ret
