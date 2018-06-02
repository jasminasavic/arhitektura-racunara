#int inter_to_roman(unsigned int broj, char *str, int duzina);
.section .text
.globl inter_to_roman
dec:    .long 1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1
rom1:   .ascii "MCDCCXLXXIVII"
rom2:   .ascii " M D C L X V "

inter_to_roman:
	pushl %ebp
	movl %esp, %ebp
	pushl %edi
	pushl %esi
	pushl %ebx
	movl 12(%ebp), %ecx #pocetak stringa
	movl %ecx, %esi
	movl 8(%ebp), %eax #broj
	# 16(%ebp) duzina bafera
	movl $1, %edx #koristicemo kao brojac, jedno mesto rezervisano za specijalni karakter "\0"
	xorl %edi, %edi #indeks niza
provera:
	cmpl 16(%ebp), %edx
	je greska
	cmpl dec(, %edi, 4), %eax #poredicemo nas broj sa brojevima u nizu dec, ako je nas broj veci, to znaci da sadrzi
				  #rimsku cifru na odgovarajucoj poziciji; npr ako smo poslali broj 151, on ce prvo da poredi
				  #sa 1000, videce da nije vece pa nastavlja dalje, poredi sa 900, nije vece, nastavlja dalje,
				  #isto tako sa 500, 400, a kad dodje do 100, skocice na racunanje
	jae racunaj
	incl %edi
	jmp provera
racunaj: #od naseg broja oduzmemo broj iz niza dec do kojeg smo stigli, kod nas je to u prvom koraku 151-100=51
	subl dec(, %edi, 4), %eax
	movb rom1(, %edi,1), %bl #iz niza rom1 upisemo odgovarajucu cifru, niz rom1 je namesten tako da se indeksi arapskih brojeva i 
				 #odogvarajucih rimskih poklapaju, s tim da ako je rimski broj dvocifren, npr. 4=IV, njegova druga cifra
				 #se nalazi u nizu rom2, za 4: u rom1 se nalazi I, u rom2 se nalazi V
	movb %bl, (%ecx)
	incl %edx
	incl %ecx 
	cmpb $' ', rom2(, %edi, 1) #kada rimsku cifru iz niza rom1 smestimo u nas string i povecamo brojac duzine, proveravamo da li u  
		  		   #nizu rom2 stoji druga cifra ili je samo razmak, ako da, idemo i nju da ispisemo
	jne pisi
	andl %eax, %eax #ako ne, testiramo da li smo dosli do kraja provere, u nasem prvom koraku ostao nam je broj 51, pa zbog toga
			#to znaci da idemo ponovo na proveru
	jz uspesno #u jednom trenutku cemo doci do toga da nam je ostao broj 0, to znaci da je kraj konverzije
	jmp provera
pisi:
	cmpl 16(%ebp), %edx #ako imamo drugu cifru, prvo moramo proveriti da li u baferu imamo mesta za nju
	je greska
	movb rom2(, %edi,1), %bl #premestamo iz rom2 u nas string
	movb %bl, (%ecx)
	incl %edx #povecamo brojac duzine
	incl %ecx #pomerimo mesto u stringu za jedno mesto
	andl %eax, %eax
	jz uspesno #ovde isto proveravamo da li smo dosli do 0, ako jesmo onda je kraj, ako ne nazad na proveru
	jmp provera
greska:
	movl $1, %eax
	jmp kraj
uspesno:
	movb $0, (%ecx)
	xorl %eax, %eax
kraj:
	popl %ebx
	popl %esi
	popl %edi
	movl %ebp, %esp
	popl %ebp
	ret
	
