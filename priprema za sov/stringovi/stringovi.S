#program broji broj reci u stringu, svi znakovi osim slova su separatori, ukoliko je pocetno ili krajnje slovo reci malo,
#menja ga u veliko
.section .data

ulaz1: .ascii "Unesite string:\0"
len1 = . - ulaz1

izlaz1: .ascii "Broj reci u stringu je:\0"
izl1 = . - izlaz1

max_len = 100
pomocni: .fill max_len, 1, 0

broj_str: .fill max_len, 1, 0

brojac_duzine: .long 0
brojac_reci: .long 0

.section .text
.globl main
main:
	movl $4, %eax
	movl $1, %ebx
	leal ulaz1, %ecx
	movl $len1, %edx
	
	int $0x80
	
	movl $3, %eax
	movl $0, %ebx
	leal pomocni, %ecx
	movl $max_len, %edx
	
	int $0x80
	
	movl %eax, %esi
	
priprema:
	xorl %edx, %edx
	xorl %edi, %edi
provera:
	movb pomocni(, %edi, 1), %dl
	cmpb $'\n', %dl
	je izuzetak
	cmpb $'A', %dl
	jb dalje_provera
	cmpb $'Z', %dl
	ja malo_provera
	incl brojac_duzine
	incl %edi
	jmp provera
dalje_provera:
	cmpl $0, brojac_duzine
	jnz izmeni
	incl %edi
	jmp provera
malo_provera:
	cmpb $'a', %dl
	jb dalje_provera
	cmpb $'z', %dl
	ja dalje_provera
	incl brojac_duzine
	incl %edi
	jmp provera
izmeni:
	movl %edi, %ebx
	subl brojac_duzine, %ebx
	decl %edi
	movb pomocni(, %edi, 1), %dl
	cmpb $90, %dl
	jbe izmeni2
	subb $32, %dl
	movb %dl, pomocni(, %edi, 1)
izmeni2:movb pomocni(, %ebx, 1), %dl
	cmpb $90, %dl
	jbe izmeni3
	subb $32, %dl
	movb %dl, pomocni(, %ebx, 1)
izmeni3:
	incl brojac_reci
	movl $0, brojac_duzine
	incl %edi
	movb pomocni(, %edi, 1), %dl
	cmpb $'\n', %dl
	je kraj_provere
	incl %edi
	jmp provera
izuzetak:
	cmpb $0, brojac_duzine
	je kraj_provere
	jmp izmeni
kraj_provere:
	
	movl $4, %eax
	movl $1, %ebx
	leal pomocni, %ecx
	movl %esi, %edx
	
	int $0x80
	
konverzija_priprema:
	movl brojac_reci, %eax
	movl $0, %esi
	movl $16, %ecx
konverzija:
	xorl %edx, %edx
	divl %ecx
	addb $'0', %dl
	cmpb $'9', %dl
	ja hex_slovo
nastavi:
	movb %dl, broj_str(, %esi, 1)
	incl %esi
	andl %eax, %eax
	jz kraj_konverzije
	jmp konverzija
hex_slovo:
	addb $7, %dl
	jmp nastavi
kraj_konverzije:
	movb $'\n', broj_str(, %esi, 1)
	incl %esi
	movl %esi, %edi
	movb $0, broj_str(, %esi, 1)
	subl $2, %esi
	xorl %eax, %eax
obrni:
	cmpl %eax, %esi
	jbe ispis
	movb broj_str(, %esi, 1), %dl
	movb broj_str(, %eax, 1), %dh
	movb %dh, broj_str(, %esi, 1)
	movb %dl, broj_str(, %eax, 1)
	decl %esi
	incl %eax
	jmp obrni
ispis:
	movl $4, %eax
	movl $1, %ebx
	leal broj_str, %ecx
	movl %edi, %edx
	
	int $0x80
	
kraj:
	movl $1, %eax
	movl $0, %ebx
	
	int $0x80
	
	
	
	
	
	
