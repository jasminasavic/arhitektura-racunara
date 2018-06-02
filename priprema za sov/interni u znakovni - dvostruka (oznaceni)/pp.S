#unsigned int inter_to_oct_str(long long int broj, char* str, unsigned int duzina)
#konverzija iz internog oblika u znakovni oblik, broj je 64-bitni
.section .text
.globl inter_to_oct_str
inter_to_oct_str:
	pushl %ebp
	movl %esp, %ebp
	subl $4, %esp
	pushl %ebx
	pushl %esi
	pushl %edi
	movl 8(%ebp), %eax #nizi biti
	movl 12(%ebp), %edx #visi biti
	movl 16(%ebp), %ecx #pocetak srtinga
	movl %ecx, -4(%ebp)
	#na 20(%ebp) je duzina bafera
	movl $1, %esi
	movl $0, %edi #baza sistema
	
	testl $80000000, %edx
	jnz negativan
	
konverzija:
	xorl %ebx, %ebx
	cmpl %esi, 20(%ebp)
	je greska_duzina
	shrl $1, %edx
	rcrl $1, %eax
	jnc dalje1
	addl $1, %ebx
dalje1:	shrl $1, %edx
	rcrl $1, %eax
	jnc dalje2
	addl $2, %ebx
dalje2:	shrl $1, %edx
	rcrl $1, %eax
	jnc dalje3
	addl $4, %ebx
dalje3:
	addb $'0', %bl
	movb %bl, (%ecx)
	incl %esi
	incl %ecx
	andl %edx, %edx
	jnz konverzija
	andl %eax, %eax
	jnz konverzija
nastavi:
	movb $0, (%ecx)
	decl %ecx
	movl -4(%ebp), %ebx
	jmp obrni
negativan:
	incl %esi
	cmpl %esi, 20(%ebp)
	je greska_duzina
	movb $'-', (%ecx)
	incl %ecx
	incl -4(%ebp)
	xorl $0xffffffff, %edx
	xorl $0xffffffff, %eax
	addl $1, %eax
	adcl $0, %edx
	jmp konverzija
	
obrni:
	cmpl %ebx, %ecx
	jbe uspesno
	movb (%ebx), %dl
	movb (%ecx), %dh
	movb %dl, (%ecx)
	movb %dh, (%ebx)
	incl %ebx
	decl %ecx
	jmp obrni
greska_duzina:
	movl $1, %eax
	jmp kraj
uspesno:
	movl $0, %eax
kraj:
	popl %edi
	popl %esi
	popl %ebx
	movl %ebp, %esp
	popl %ebp
	ret
