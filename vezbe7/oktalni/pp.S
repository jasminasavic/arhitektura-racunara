#unsigned int inter_to_oct_str(unsigned int broj, char* str, unsigned int duzina);
.section .text
.globl inter_to_oct_str
inter_to_oct_str:
	pushl %ebp
	movl %esp, %ebp
	pushl %ebx
	pushl %esi
	pushl %edi
	movl 8(%ebp), %eax #broj za konverziju
	movl 12(%ebp), %ecx # pocetak stringa
	movl %ecx, %edi #sacuvamo ga jos jednom posto cemo se pomerati od pocetne adrese
	#16(%ebp) duzina
	cmpl $0, 16(%ebp) #ukoliko je duzina bafera nula, nemamo mesta za konverziju
	je greska
	movl $8, %ebx #osnova brojnog sistema u koji konvertujemo
	movl $1, %esi #brojac elemenata stringa stavljamo na 1 posto odmah pretpostavljamo jedno mesto za "\0"
okt_broj:
	cmpl %esi, 16(%ebp) #kada nam brojac elemenata bude jednak duzini bafera, tada idemo da proverimo da li smo
	#zavrsili konverziju pre nego sto nam je nestalo mesta (tj. broj nam taman staje u string) - sto znaci da
	# je sve uredu  ili jos uvek nismo zavrsili konverziju a nemamo mesta, sto znaci da je doslo do greske
	je provera
	xorl %edx, %edx #edx moramo da cistimo da nam ne ostane nesto u njemu
	divl %ebx #delimo nas broj sa osnovom
	addb $'0', %dl #posto je broj u internoj predstavi, moramo ga konvertovati u znakovnu. 0 se nalazi na '0'=48, 1 na '1'=49 itd.
	#zato dodajemo ascii mesto 0 na svaki broj kako bismo dobili njegovu znakovnu predstavu
	movb %dl, (%ecx) #znak smestamo u string
	incl %esi #povecavamo brojac nasih mesta
	incl %ecx #povecavamo adresu za 1, tj. na mesto za sledeci element niza
	andl %eax, %eax #proveravamo da li je nas broj 0, ako jeste, zavrsili smo konverziju, ako nije, idemo dalje
	jnz okt_broj
	
	#rezultujuci string ce biti obrnut. npr ako smo uneli dekadni broj koji glasi
	#1234 u oktalnoj predstavi, nas string ce izgledati "4321". ono sto treba da uradimo
	# je: ubaciti null karakter na kraj, pa imamo "4321\0", i na kraju jos da obrnemo string (ne dirajuci null karakter)
	#kako bismo na kraju dobili: "1234\0".
	
dalje:
	movb $0, (%ecx) #stavljamo specijalni karakter '\0' na poslednje mesto u stringu
	decl %ecx #smanjujemo poziciju za jedan, kako bi nasa adresa bila na poslednjoj cifri, a ne na '\0' karakteru
obrni:
	cmpl %ecx, %edi #ecx sadrzi adresu poslednje, a edi prve cifre. edi cemo povecavati, a ecx smanjivati. kada
	#edi postane veci od ili jednak sa ecx, znaci da smo zavrsili obrtanje.
	jae uspesno
	movb (%edi), %dl 
	movb (%ecx), %dh
	movb %dl, (%ecx)
	movb %dh, (%edi)
	decl %ecx
	incl %edi
	jmp obrni
provera: #ovde proveravamo da li smo dosli do kraja konverzije kad nam je ponestalo mesta za pisanje znakova
#ovo se moglo odraditi drugacije, pogledati zadatak oktalni-oznaceno
	andl %eax, %eax
	jnz greska
	jz dalje
greska: 
	movl $1, %eax #povratna vrednost za kod greske ukoliko je do nje doslo je 1
	jmp kraj
uspesno: #ukoliko je nas potprogram uspeno odradio posao, stavljamo 0 u eax, posto nam je to povratna vrednost greske
#ukoliko do nje nije doslo
	xorl %eax, %eax
	
kraj:
	popl %edi	
	popl %esi
	popl %ebx
	movl %ebp, %esp
	popl %ebp
	ret
