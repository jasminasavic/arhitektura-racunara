#korisnik salje preko pokazivaca 32-bitni broj. ukoliko u binarnom zapisu tog broja postoji nula okruzena sa dve jedinice 
#pretvoriti je u nulu. npr. ako korisnik posalje adresu broja 5, on je u binarnom zapisu 0101, pretvorice ovaj broj u 0111.
.section .text
.globl from101to111
#int from101to111(int* v);
from101to111:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %ecx
	movl (%ecx), %eax
	movl $1, %edx
provera:
	cmpl $0, %edx
	je kraj
	testl %edx, %eax
	jnz dalje1
	shll $1, %edx
	jmp provera
dalje1:
	shll $1, %edx
	cmpl $0, %edx
	je kraj
	testl %edx, %eax
	jz dalje2
	shll $1, %edx
	jmp provera
dalje2:
	shll $1, %edx
	cmpl $0, %edx
	je kraj
	testl %edx, %eax
	jnz maska
	shll $1, %edx
	jmp provera
maska:
	shrl $1, %edx
	xorl %edx, %eax
	shll $1, %edx
	jmp provera
	
kraj:
	movl %ebp, %esp
	popl %ebp
	ret
	
	
	
	
	
