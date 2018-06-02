#unsigned int inter_to_oct_str_float(unsigned int broj, char* str, unsigned int duzina);


#kada se konvertuju razlomljeni brojevi, nema potrebe za obrtanjem stringa
#konvertuje se iz skaliranog oblika (broj*10^8) u oblik sa decimalnim zarezom


.section .text
.globl inter_to_oct_str_float
inter_to_oct_str_float:
	pushl %ebp
	movl %esp, %ebp
	pushl %ebx
	pushl %esi
	pushl %edi
	movl 8(%ebp), %eax #nas broj je na eax
	movl 12(%ebp), %ecx #pocetak stringa
	#16(%ebp) duzina bafera
	cmpl $3, 16(%ebp) #ako je duzina bafera manja od 3 nemamo mesta za konverziju
	jbe greska
	movl $8, %ebx #baza sistema iz kojeg konvertujemo
	movl $3, %esi #postavljamo nas brojac odmah na 3
	movb $'0', (%ecx)
	incl %ecx		#postavljamo '0' i '.' u string
	movb $'.', (%ecx)
	incl %ecx
	movl $100000000, %edi #stavljamo 10^8 u edi
razlomljeni:
	cmpl 16(%ebp), %esi
	je ispis #kod razlomljenih brojeva ne brinemo dalje o duzini bafera, jer cemo samo izgubiti na preciznosti
	#ako ne upisemo neku od cifara, a to se ne tretira kao greska
	mull %ebx #mnozimo nas broj sa bazom sistema u koji pretvaramo
	divl %edi #delimo sa 10^8
	#u edx-u ce nam ostati ostatak ovog deljenja. ostatak deljenja ide dalje u obradu. kolicnik se upisuje u stirng.
	
	#npr. broj 0.3125(10) treba pretvoriti u oktalni broj. dobijamo ga kao skaliranog 0.3125*10^8=31250000
	# prvo radimo: 31250000*8=250000000.
	# to znaci da nam 2 ide u string (posto je 2 na 9om mestu), a 50000000 ide dalje u obradu
	# dakle, ovde 250000000 delimo sa 10^8. u eax ostaje 2, to upisujemo u string, 50000000 je u edx, njega treba
	# staviti u eax kako bismo mogli da ponovimo postupak sa njime
	# pa onda 50000000*8=400000000
	# 4000000000 / 10^8. eax=4, edx=0
	# eax-> string, edx-> eax, znaci sad je eax=0. kada je eax=0, algoritam je zavrsen
	
	addb $'0', %al #na nasu cifru u eax dodajemo kod znaka nula, kako bismo dobili znakovnu predstavu
	movb %al, (%ecx) #upisivanje u string
	movl %edx, %eax #premestamo onaj ostatak pri deljenju u eax
	incl %esi #povecavamo brojac elemenata
	incl %ecx #povecavamo poziciju za 1
	andl %eax, %eax #ako nismo zavrsili konverziju (stigli do 0) idemo dalje na konverziju
	jnz razlomljeni
ispis:
	movb $0, (%ecx)
	xorl %eax, %eax
	jmp kraj
greska:
	movl $1, %eax
kraj:
	movl %ebp, %esp
	popl %ebp
	ret
