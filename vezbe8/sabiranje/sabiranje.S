
.section .data
ulaz1:      .ascii "Unesite bazu broja:\0"
len1 = . - ulaz1
ulaz2:      .ascii "Unesite broj:\0"
len2 = . - ulaz2
ulaz3:      .ascii "Unesite bazu rezultata:\0"
len3 = . - ulaz3
izlaz1:     .ascii "Rezultat:\0"
rez = . - izlaz1
greska1:    .ascii "Greska: pogresan znak!\n\0" #-1
gr1 = . - greska1
greska2:    .ascii "Greska: prekoracenje!\n\0"
gr2 = . - greska2

broj1: .long 0
broj2: .long 0
rezultat: .long 0
	
STRING_MAX = 100
pomocni: .fill STRING_MAX, 1, 0

baza1: .long 0
baza2: .long 0
baza3: .long 0

greska_kod1: .byte 0
greska_kod2: .byte 0
.section .text
.globl main


########################################
	#pushl $broj1
	#pushl baza1
	#pushl $pomocni
konvertuj_pp:
	pushl %ebp
	movl %esp, %ebp
	subl $4, %esp
	pushl %ebx
	pushl %edi
	movl 16(%ebp), %ecx
	movl 12(%ebp), %edx
	movl %edx, -4(%ebp)
	movl 8(%ebp), %edi
	xorl %ebx, %ebx
	xorl %eax, %eax
konverzija_pp:
	movb (%edi), %bl
	cmpb $'\n', %bl
	je zavrseno
	mull -4(%ebp)
	andl %edx, %edx
	jnz vrati_gresku_2
	subb $'0', %bl
	cmpb $9, %bl
	ja slovo
nastavi:
	cmpl -4(%ebp), %ebx
	jae vrati_gresku_1
	addl %ebx, %eax
	jc vrati_gresku_2
	incl %edi
	jmp konverzija_pp
slovo:
	subb $7, %bl
	jmp nastavi
vrati_gresku_2:
	movb $1, greska_kod2
	jmp kraj_pp
vrati_gresku_1:
	movb $1, greska_kod1
	jmp kraj_pp
zavrseno: 
	movl %eax, (%ecx)
kraj_pp:
	
	popl %ebx
	movl %ebp, %esp
	popl %ebp
	ret

########################################
########################################
	#pushl $rezultat
	#pushl baza3
	#pushl $pomocni
konvertuj_znak:
	pushl %ebp
	movl %esp, %ebp
	subl $4, %esp
	pushl %esi
	pushl %ebx
	pushl %edi
	movl 8(%ebp), %ecx
	movl %ecx, -4(%ebp)
	movl $1, %esi
	movl 12(%ebp), %edi #baza
	movl 16(%ebp), %eax #broj za konverziju
konverzija:
	andl %eax, %eax
	jz dalje_znak
	xorl %edx, %edx
	divl %edi
	addb $'0', %dl
	cmpb $'9', %dl
	ja slovo_znak
nastavi_znak:
	movb %dl, (%ecx)
	incl %ecx
	incl %esi
	jmp konverzija
slovo_znak:
	addb $7, %dl
	jmp nastavi_znak
dalje_znak:
	movl $'\n', (%ecx)
	incl %esi
	incl %ecx
	movb $0, (%ecx)
	subl $2, %ecx
	movl -4(%ebp), %edi
obrni_znak:
	cmpl %edi, %ecx
	jbe kraj_znak
	movb (%edi), %dl
	movb (%ecx), %dh
	movb %dh, (%edi)
	movb %dl, (%ecx)
	incl %edi
	decl %ecx
	jmp obrni_znak
	
kraj_znak:
	movl %esi, %eax
	popl %edi
	popl %ebx
	popl %esi
	movl %ebp, %esp
	popl %ebp
	ret
########################################

main:
	movl $4, %eax #ulaz 1, broj 1
	movl $1, %ebx
	leal ulaz1, %ecx
	movl $len1, %edx
	
	int $0x80
	
	movl $3, %eax #unos baze broja 1
	movl $0, %ebx
	leal pomocni, %ecx
	movl $STRING_MAX, %edx
	int $0x80
	
	
	
	pushl $baza1 #konverzija baze
	pushl $10
	pushl $pomocni
	call konvertuj_pp
	addl $12, %esp
	
	cmpb $0, greska_kod2
	jne isipisi_gresku2
	
	cmpb $0, greska_kod1
	jne isipisi_gresku1
	
	cmpl $2, baza1
	jb isipisi_gresku1
	cmpl $36, baza1
	ja isipisi_gresku1
	
	movl $4, %eax #ulaz2, broj 1
	movl $1, %ebx
	leal ulaz2, %ecx
	movl $len2, %edx
	
	int $0x80
	
	movl $3, %eax #unos broja 1
	movl $0, %ebx
	leal pomocni, %ecx
	movl $STRING_MAX, %edx
	int $0x80
	
	pushl $broj1
	pushl baza1
	pushl $pomocni
	call konvertuj_pp
	addl $12, %esp
	
	cmpb $0, greska_kod2
	jne isipisi_gresku2
	
	cmpb $0, greska_kod1
	jne isipisi_gresku1
	
	
	
	movl $4, %eax #ulaz 1, broj 2
	movl $1, %ebx
	leal ulaz1, %ecx
	movl $len1, %edx
	
	int $0x80
	
	movl $3, %eax #unos baze broja 2
	movl $0, %ebx
	leal pomocni, %ecx
	movl $STRING_MAX, %edx
	int $0x80
	
	
	pushl $baza2 #konverzija baze
	pushl $10
	pushl $pomocni
	call konvertuj_pp
	addl $12, %esp
	
	cmpb $0, greska_kod2
	jne isipisi_gresku2
	
	cmpb $0, greska_kod1
	jne isipisi_gresku1
	
	cmpl $2, baza2
	jb isipisi_gresku1
	cmpl $36, baza2
	ja isipisi_gresku1
	
	movl $4, %eax #ulaz2, broj 2
	movl $1, %ebx
	leal ulaz2, %ecx
	movl $len2, %edx
	
	int $0x80
	
	movl $3, %eax #unos broja 2
	movl $0, %ebx
	leal pomocni, %ecx
	movl $STRING_MAX, %edx
	int $0x80
	
	pushl $broj2
	pushl baza2
	pushl $pomocni
	call konvertuj_pp
	addl $12, %esp
	
	cmpb $0, greska_kod2
	jne isipisi_gresku2
	
	cmpb $0, greska_kod1
	jne isipisi_gresku1
	
	
	
	movl $4, %eax #ulaz 3, rezultat
	movl $1, %ebx
	leal ulaz3, %ecx
	movl $len3, %edx
	
	int $0x80
	
	movl $3, %eax #unos baze rezultata
	movl $0, %ebx
	leal pomocni, %ecx
	movl $STRING_MAX, %edx
	int $0x80
	
	
	
	pushl $baza3 #konverzija baze
	pushl $10
	pushl $pomocni
	call konvertuj_pp
	addl $12, %esp
	
	cmpb $0, greska_kod2
	jne isipisi_gresku2
	
	cmpb $0, greska_kod1
	jne isipisi_gresku1
	
	cmpl $2, baza3
	jb isipisi_gresku1
	cmpl $36, baza3
	ja isipisi_gresku1
saberi:
	movl broj2, %eax
	addl broj1, %eax
	movl %eax, rezultat
	
konverzija_rezultata:
	pushl rezultat
	pushl baza3
	pushl $pomocni
	call konvertuj_znak
	addl $12, %esp
	
	movl %eax, %esi
	
pisi_rezultat:
	movl $4, %eax 
	movl $1, %ebx
	leal izlaz1, %ecx
	movl $rez, %edx
	
	int $0x80
	
	movl $4, %eax 
	movl $1, %ebx
	leal pomocni, %ecx
	movl %esi, %edx
	
	int $0x80
	
	jmp kraj
isipisi_gresku2:
	movl $4, %eax 
	movl $1, %ebx
	leal greska2, %ecx
	movl $gr2, %edx
	
	int $0x80
	
	jmp kraj
	
isipisi_gresku1:
	movl $4, %eax 
	movl $1, %ebx
	leal greska1, %ecx
	movl $gr1, %edx
	
	int $0x80
kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
