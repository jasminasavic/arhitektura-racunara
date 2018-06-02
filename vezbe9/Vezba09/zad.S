# podaci drajvera ekrana
.section .data

# promenljive dostupne iz glavnog C programa
.extern scrwidth    # širina emuliranog ekrana
.extern scrheight   # visina emuliranog ekrana
.extern screen      # memorija emuliranog ekrana (scrwidth x scrheight)
.extern scrsize     # broj bajtova emuliranog ekrana (scrwidth*scrheight)

# interni podaci drajvera ekrana
cursorx:    .long 0 # x koordinata kursora
cursory:    .long 0 # y koordinata kursora
pbuff:      .fill 100,1,0   # bafer za generisanje ispisa na ekran

.section .text
.globl clearscr
.globl gotoxy
.globl printchr
.globl printstr
.globl printnum

#void clearscr();
clearscr:
	pushl %ebp
	movl %esp, %ebp
	movl scrwidth, %ecx
brisi:
	cmpl scrsize, %eax
	je kraj
	movl scrwidth, %eax
	xorl %edx, %edx
	mull cursory
	addl cursorx, %eax
	movb $' ', screen( ,%eax, 1)
	incl cursorx
	cmpl cursorx, %ecx
	je povecaj_y
	jmp brisi
povecaj_y:
	incl cursory
	movl $0, cursorx
	jmp brisi
	
kraj:	movl $0, cursorx
	movl $0, cursory
	movl %ebp, %esp
 	popl %ebp
	ret

#int gotoxy(int x, int y);
gotoxy:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %ecx
	movl 12(%ebp), %edx
proveri_x:
	cmpl %ecx, scrwidth
	jbe pogresno
proveri_y:
	cmpl %edx, scrheight
	jbe pogresno
	movl %ecx, cursorx
	movl %edx, cursory
	xorl %eax, %eax
	jmp kraj_pretrage
pogresno:
	movl $1, %eax
	
kraj_pretrage:
	movl %ebp, %esp
 	popl %ebp
	ret

#void printchr(int chr);
printchr:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %ecx
izuzetak1:
	cmpb $'\n', %cl
	je povecaj_y1
izuzetak2:
	cmpb $'\t', %cl
	je tabulator
izuzetak3:
	cmpb $'\r', %cl
	je kursor_pocetak
pisi:
	movl scrwidth, %eax
	mull cursory
	addl cursorx, %eax
	movb %cl, screen(, %eax, 1)
	incl cursorx
	movl scrwidth, %edx
	cmpl cursorx, %edx
	je povecaj_y1
	jmp kraj1
tabulator:
	xorl %edx, %edx
	movl $10, %ecx
	movl cursorx, %eax
	divl %ecx
	subl %edx, cursorx
	addl %ecx, cursorx
	movl cursorx, %eax
	cmpl scrwidth, %eax
	jae povecaj_y1
	jmp kraj1

povecaj_y1:
	incl cursory
	movl $0, cursorx
	movl scrheight, %edx
	cmpl cursory, %edx
	je skrol_p
	jmp kraj1
skrol_p:
	xorl %eax, %eax
	movl scrwidth, %edx
skrol:
	cmpl %edx, scrsize
	je ocisti_poslednji
	movb screen(, %edx, 1), %cl
	movb %cl, screen(, %eax, 1)
	incl %eax
	incl %edx
	jmp skrol
ocisti_poslednji:
	subl scrwidth, %edx
obrisi:
	cmpl %edx, scrsize
	je kursor
	movb $' ', screen(, %edx, 1)
	incl %edx
	jmp obrisi
kursor_pocetak:
	movl $0, cursorx
	jmp kraj1
kursor:
	movl scrheight, %eax
	decl %eax
	movl %eax, cursory
	movl $0, cursorx
	
kraj1:
	movl %ebp, %esp
 	popl %ebp
	ret


#void printstr(char* str);
printstr:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %ecx
pisi_string:
	xorl %edx, %edx
	movb (%ecx), %dl
	cmpb $0, %dl
	je kraj2
	pushl %ecx
	pushl %edx
	call printchr
	addl $4, %esp
	popl %ecx
	incl %ecx
	jmp pisi_string
kraj2:
	movl %ebp, %esp
 	popl %ebp
	ret

#void printnum(int num);
printnum:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %eax
	pushl %esi
	pushl %edi
	xorl %edi, %edi
	movl $10, %ecx
	movl $0, %esi
	cmpl $0, %eax
	jge konverzija
	movb $'-', pbuff(, %esi, 1)
	incl %esi
	incl %edi
	negl %eax
konverzija:
	xorl %edx, %edx
	divl %ecx
	addb $'0', %dl
	movb %dl, pbuff(, %esi, 1)
	incl %esi
	andl %eax, %eax
	jnz konverzija
dalje:
	movb $0, pbuff(, %esi, 1)
	decl %esi
obrni:
	cmpl %esi, %edi
	jae pozovi_ispis
	movb pbuff(, %esi, 1), %cl
	movb pbuff(, %edi, 1), %ch
	movb %ch, pbuff(, %esi, 1)
	movb %cl, pbuff(, %edi, 1)
	incl %edi
	decl %esi
	jmp obrni
pozovi_ispis:
	pushl $pbuff
	call printstr
	addl $4, %esp
kraj_broj:
	popl %edi
	popl %esi
	movl %ebp, %esp
 	popl %ebp
	ret
	
	
	
	
	
	
	
	
	

