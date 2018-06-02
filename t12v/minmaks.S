#dobijena su 3 broja u dvostrukoj preciznosti. treba naci najmanji od ta 3 i sabrati dva veca. upisati najmanji u promenljivu
#minimum a zbirk ova dva u zbir_max.
#npr. ako je a=10, b=1, c=55, onda: minimum=1, zbir_max=65.
.section .data
	a: .quad 0x110000001
	b: .quad 0x110000000
	c: .quad 0x120000001
	zbir_max: .quad 0
	minimum: .quad 0
.section .text
.globl main
main: #prvo saberemo sve brojeve, pa kada nadjemo minimum, oduzecemo od zbira (to znaci da ce za zbir zaista ostati na kraju samo 2 najveca
      #i trazeno u zadatku)
	movl $0, %eax
	movl $0, %ebx      
	addl a, %eax
	adcl a+4, %ebx
	addl b, %eax
	adcl b+4, %ebx
	addl c, %eax
	adcl c+4, %ebx
	movl %eax, zbir_max
	movl %ebx, zbir_max+4
	movl a, %eax #pretpostavicemo da je broj a minimum
	movl a+4, %ebx
trazi_min: 
	cmpl b+4, %ebx #poredimo prvo znacajnije cifre, ako su znacajnije cifre a > od znacajnijih cifara b, odmah skacemo da poredimo
			# b i c, ako su zn. cifre b > od zn. cifara a, znaci da treba odmah da poredimo a i c
	jb min_a
	ja min_b
	cmpl b, %eax #ukoliko su im znacajnije cifre jednake, poredimo manje znacajne
	ja min_b #ako su manje zn. cifre a > od manje zn. cifara b, znaci da treba da poredimo jos b i c, a ako
		 # su manje zn. cifre b >= od manje zn. cifara a, treba da poredimo jos sa c (propadamo dole)
min_a:	cmpl c+4, %ebx
	jb suma #ako su znacajnije cifre c > od zn. cifara a, a je min i mozemo odmah da idemo da a oduzmemo od sume
	ja min_c #ako vazi obrnuto, c je min (posto je a<b i c<a => c<a<b) pa idemo da prebacimo c u registre %eax i %ebx
		 # kako bismo mogli da oduzmemo od sume i prebacimo u promenljivu minimum
	cmpl c, %eax #ako su zn. cifre a i c iste, proveracamo manje znacajne
	jb suma #ako su manje zn. cifre c> od manje zn. cifara a, a je min i mozemo odmah da idemo da a oduzmemo od sume
	jmp min_c #ako su manje zn. cifre c<= a, to znaci da je c min i skacemo da da prebacimo c u registre....
	
min_b: # ovde se slicno vrsi proces poredjenja, ali samo za promenljive b i c
	movl b, %eax
	movl b+4, %ebx
	cmpl c+4, %ebx
	jb suma
	ja min_c
	cmpl c, %eax
	jb suma
min_c:	movl c, %eax
	movl c+4, %ebx
	jmp suma
	#nakon ovog dela, minimum bi trebalo da se nalazi u %eax i %ebx pa idemo da ga oduzmemo od sume
suma:
	subl %eax, zbir_max
	sbbl %ebx, zbir_max+4
	
kraj:
	movl %eax, minimum #prebacujemo minimum iz registara u promenljivu
	movl %ebx, minimum+4
	movl $1, %eax
	movl $0, %ebx
	int $0x80
