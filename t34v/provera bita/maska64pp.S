#korisnik salje adrese dva 64-bitna broja. treba uporediti najznacajnije bite (nulti i 63-i) i ako su
#oni jednaki vratiti 1. bbroj invertovan i povratnu vrednost 1
#ako su najznacajniji biti razliciti, invertovati 2. broj i povratna vrednost je 2
.section .text
.globl maska64pp
maska64pp:
	pushl %ebp
	movl %esp, %ebp
	pushl %ebx 
	pushl %edi
	pushl %esi
	movl 8(%ebp), %edi
	movl (%edi), %eax
	movl 4(%edi), %ebx
	movl 12(%ebp), %edi
	movl (%edi), %ecx
	movl 4(%edi), %edx
	movl $1, %esi #maska 0b00000000000000000000000000000001 (31 nula i 1)
nizi:
	testl %esi, %eax
	jnz jedinica_nizi
	testl %esi, %ecx
	jnz nisu_isti
	jz nizi_isti
jedinica_nizi:
	testl %esi, %edx
	jz nisu_isti
	jnz nizi_isti
nizi_isti:
	rorl $1, %esi  #maska 0b10000000000000000000000000000000 (jedna jedinica i 31 nula)
	testl %esi, %ebx
	jne jedinica_visi
	testl %esi, %edx
	jnz nisu_isti
	jz isti
jedinica_visi:
	testl %esi, %edx
	jz nisu_isti
isti:
	movl 8(%ebp), %edi
	notl %eax
	notl %ebx
	movl  %eax, (%edi)
	movl  %ebx, 4(%edi)
	movl $1, %eax
	jmp kraj
nisu_isti:	
	notl %ecx
	notl %edx
	movl %ecx, (%edi)
	movl %edx, 4(%edi)
	movl $2, %eax
kraj:
	popl %esi
	popl %edi
	popl %ebx
	movl %ebp, %esp
	popl %ebp
	ret
	
	
	
	
	
	
	
	
	
	
	
	
	
