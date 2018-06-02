.section .data
.section .text
.globl main
main:
	movl $12, %eax
	movl $8, %ebx
uporedi:
	cmpl %eax, %ebx
	je kraj
	cmpl %ebx, %eax
	ja vece
	subl %eax, %ebx
	jmp uporedi
vece:
	subl %ebx, %eax
	jmp uporedi
kraj: 
	movl $1, %eax
	movl $0, %ebx
	int $0x80
