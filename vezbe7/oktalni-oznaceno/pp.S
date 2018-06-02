#unsigned int inter_to_oct_str(int broj, char* str, unsigned int duzina);
.section .text
.globl inter_to_oct_str
inter_to_oct_str:
	pushl %ebp
	movl %esp, %ebp
	pushl %ebx
	pushl %esi
	pushl %edi
	movl 8(%ebp), %eax
	movl 12(%ebp), %ecx
	movl %ecx, %edi #u edi pamtimo pocetak stringa, posto iako je u ecx pocetak stringa, njega cemo pomerati
	#16(%ebp) duzina
	cmpl $0, 16(%ebp)
	je greska
	movl $8, %ebx #baza sistema
	movl $1, %esi #broj znakova koje smo iskoristili cemo odmah staviti na 1, jer moramo obavezno ukljuciti "\0" u string
	cmpl $0, %eax # algoritam za konverziju radi isto kao sa neoznacenim brojevima, samo ako je broj negativan, 
	# moracemo da ga pripremimo za konverziju
	jl pripremi_negativan
pozitivan: #ovde je konverzija ista kao za neoznacene
	cmpl 16(%ebp), %esi
	je greska
	xorl %edx, %edx
	divl %ebx
	addb $'0', %dl
	movb %dl, (%ecx)
	incl %ecx
	incl %esi
	andl %eax, %eax
	jnz pozitivan
dalje: #kada zavrsimo sa konverzijom, premestamo null karakter na kraj stringa, smanjujemo adresu za jedan da pokaazuje na 
#poslednju cifru i idemo na obrtanje stringa
	movb $0, (%ecx)
	decl %ecx
	jmp obrni
pripremi_negativan: #moramo da broj pomnozimo sa -1 da upisemo negativan predznak, odnosno "-" u string
	imull $-1, %eax #imul radi sa oznacenim brojevima, radi sledece: operand1*operand2=rez, rez->operand2, operand2 mora bit registar
	#ovde smo negativan broj pretvorili u pozitivan, posto algoritam radi samo sa pozitivnim brojevima
	movb $45, (%edi) #premestam znak minusa na prvu poziciju u stringu
	incl %edi #povecavam lokaciju gde je pocetak stringa jer posle kad budemo obrtali brojeve necemo kretati od prve 
		  #pozicije vec od prve sledece jer je na prvoj minus
	incl %ecx #povecavamo i ecx jer se i on nalazi na pocetku gde je minus
	incl %esi #povecavamo i broj znakova koji smo iskoristili
negativan: #sve isto kao kod pozitivnih
	cmpl 16(%ebp), %esi
	je greska
	xorl %edx, %edx
	divl %ebx
	addb $'0', %dl
	movb %dl, (%ecx)
	incl %ecx
	incl %esi
	andl %eax, %eax
	jnz negativan
	jz dalje
obrni: #obrtanje stringa radi isto
	cmpl %ecx, %edi
	jae uspesno
	movb (%ecx), %al
	movb (%edi), %ah
	movb %al, (%edi)
	movb %ah, (%ecx)
	incl %edi
	decl %ecx
	jmp obrni
uspesno:
	xorl %eax, %eax
	jmp kraj
greska:
	movl $1, %eax
kraj:
	popl %edi	
	popl %esi
	popl %ebx
	movl %ebp, %esp
	popl %ebp
	ret
