.section .text
.globl SetParity
SetParity:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %ecx
	pushl %ebx
	pushl %edi
	
	movl $0, %edi #brojac
	movl $1, %edx #maska
	movl $0, %ebx #suma
	movw (%ecx), %ax #vrednost sa primljene adrese cuvamo u registar %ax
provera:
	cmpl $15, %edi #kada smo poredili 15 bitova, znaci da je kraj petlje
	je parnost
	testl %edx, %eax
	jnz dodaj
	shrl $1, %eax #shiftovanje u desno
	incl %edi
	jmp provera
dodaj:
	incl %ebx
	shrl $1, %eax
	incl %edi
	jmp provera
parnost:
	shrl $1, %ebx
	jc neparan
	movl $0, %eax
	jmp kraj
neparan:
	orw $0x8000, (%ecx) #ukoliko je bit pariteta 1, postavlja 1 na 16. bit broja
	movl $1, %eax
kraj:
	popl %edi
	popl %ebx
	movl %ebp, %esp
	popl %ebp
	ret
	
	
	
	
	
	
	
	
