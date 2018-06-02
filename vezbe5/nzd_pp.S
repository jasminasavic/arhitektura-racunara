.section .text
.globl nzd
nzd:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %eax
	movl 12(%ebp), %ecx
uporedi:
	cmpl %eax, %ecx
	je kraj
	cmpl %ecx, %eax
	ja vece
	subl %eax, %ecx
	jmp uporedi
vece:
	subl %ecx, %eax
	jmp uporedi
kraj:
	movl %ebp, %esp
	popl %ebp
	ret
