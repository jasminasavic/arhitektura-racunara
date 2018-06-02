#dobija se 32 bitni broj preko adrese. uporediti najmanje znacajan i najznacajniji bit
#ako su jednaki rotirati levo broj za 4 mesta i povratna vrednost je 4
# ako nisu, rotrirati broj desno 8 mesta i vratiti 8
.section .text
.globl maska32pp
maska32pp:
	pushl %ebp
	movl %esp, %ebp
	pushl %ebx
	movl 8(%ebp), %ebx
	movl (%ebx), %ecx #broj
	movl $8, %eax #povratna vrednost
	movl $1, %edx #maska
provera:
	testl %edx, %ecx
	jnz jedinica
	rorl %edx
	testl %edx, %ecx
	jnz nisu_isti
	jz isti
jedinica:
	rorl %edx
	testl %edx, %ecx
	jz nisu_isti
	jnz isti
isti:
	roll $4, %ecx
	movl $4, %eax
	jmp kraj
nisu_isti:
	rorl $8, %ecx
kraj:
	movl %ecx, (%ebx)
	movl %ebp, %esp
	popl %ebp
	ret
