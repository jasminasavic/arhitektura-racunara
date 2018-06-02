#int funkcija(char *);
#funkcija u c-u je napravljena tako da se moze uneti samo string bez razmaka
#tako da ce nas string sadrzati samo slova i ostale znakove 

#program treba da pronadje reci u stringu koje pocinju i zavrsavaju se istim slovom

#program ce da radi na sledeci nacin: prolazimo redom kroz string i proveravamo da li je krakter znak ili ne
#ako nije, brojac ostaje 0, ako jeste, povecamo brojac (kako bismo znali duzinu reci da mozemo da proverimo da li su
#poslednje i prvo slovo isti), medjutim, svaki put kada naidjemo na znak, proveravacemo da li je brojac 0 ili 
#neka druga vrednost, jer ako je brojac npr. 3, to znaci da smo pre tog znaka izbrojali rec od 3 slova, i sada
#moramo proveriti da li su 1. i poslednje slovo u toj reci jednaki, ako jesu, povecamo brojac takvih reci za 1
#primer. imamo string "adh$%^12LkmL34%"
#0-ti karakter je slovo, znaci povecamo brojac na 1, (indeks je 0, kad proverimo povecamo da indeks bude 1, da proverimo sledeci)
#1-vi karakter je slovo, brojac na 2 (indeks povecamo na 2, da proverimo sledeci, tj 2gi karakter)
#2-gi karakter je slovo, brojac na 3 (indeks povecamo na 3, da proverimo sledeci, 3i karakter)
#3. karakter nije slovo! da li je nas brojac 0? nije! znaci idemo da proverimo slova u nasoj prethodnoj reci
#kako to radimo? indeks nam stoji na broju 3, a brojac je 3, znaci prvo slovo se nalazi na poziciji indeks-brojac, tj 3-3=0
# poslednje slovo se nalazi na poziciji indeks-1, tj 3-1=2.
# poredimo 0-ti i 2-i karakter. da li su isti? nisu. ne povecavamo brojac reci, ali povecamo indeks za 2 (posto smo ga bili smanjili za
#1, a hocemo da predjemo na sledeci karakter), i moramo da vratimo 0 u brojac duzine reci, kako bismo mogli da od pocetka brojimo
# duzinu sledece reci kada naidjemo na nju!!!!!!!
# sada nam je indeks 4, brojac reci je i dalje 0, brojac duzine reci smo vratili na 0
#4. karakter je %, nije slovo, idemo da proverimo brojac duzine reci. brojac duzine reci je 0. to znaci da nemamo
#reci koje treba da proerimo, pa samo povecamo indeks i idemo dalje
#5. karakter je ^, nije slovo, brojac duzine reci je i dalje 0, povecamo indeks
#6. karakter nije slovo, -||-
#7. karakter nije slovo. -||-
#8. karakter je slovo! povecamo brojac na 1, povecamo indeks za 1
#9. karakter je slovo! brojac na 2, indeks povecamo za 1
#10. karakter je slovo! brojac na 3, indeks povecan za 1
#11. karakter je slovo! brojac na 4, indeks +1
#12. karakter NIJE slovo! kakav je brojac duzine reci? nije 0, vec 4! znaci imamo rec da proveravamo
# proveravamo karakter na 12-4=8mom mestu i na 12-1=11om mestu. da li su isti? jesu! povecamo brojac reci na 1 jer smo upravo
#pronasli rec koja nam odgovara! vratimo brojac duzine reci na 0, indeks povecamo za 2, da mozemo da proverimo sledeci da li je znak itd.
#13. karakter nije slovo, brojac duzine reci je i dalje 0, povecamo indeks
#14. karakter nije slovo, -||-
#15. karakter nije slovo. -||-
# 16. karakter je specijalni karakter \0. moramo proveriti izuzetak (objasnicu dole)
#ovo je samo algoritamski kako program radi da ti bude jasnije

.section .text
.globl funkcija
funkcija:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %eax #u eax-u je pocetna adresa stringa
	pushl %edi
	pushl %ebx #ova tri ce mi trebati za sve one brojace
	pushl %esi
	movl $0, %ecx #indeks koji ce redom prolaziti kroz string da proveri da li je karakter znak ili slovo
	movl $0, %edx #on mi broji duzinu reci
	movl $0, %edi #u edi cu praviti indeks prvog slova u reci. njega cu racunati: stavim vrednost ecx u njega, pa oduzmem vrednost edx
	movl $0, %ebx #on mi treba da iskoristim %bl, zbog porednjenja karaktera
	movl $0, %esi #on nam je brojac reci koje imaju isto prvo i poslednje slovo
proveri_znak:
	cmpb $0, (%eax, %ecx, 1)
	je izuzetak #kada dodjemo do kraja stringa moramo paziti na izuzetak!
	cmpb $64, (%eax, %ecx, 1)
	ja dalje1
	jmp nije_slovo
dalje1:
	cmpb $91, (%eax, %ecx, 1)
	jb slovo
	cmpb $96, (%eax, %ecx, 1)	#proveri_znak, dalje1 i dalje 2 sluze da provere da li je karakter slovo ili ne
	ja dalje2
	jmp nije_slovo
dalje2:
	cmpb $123, (%eax, %ecx, 1)
	jb slovo
	jmp nije_slovo
slovo: #ako jeste slovo, povecavacemo brojac duzine reci edx, i index ecx
	incl %edx
	incl %ecx
	jmp proveri_znak
nije_slovo: #ako nije slovo moramo:
	cmpl $0, %edx #da proverimo duzinu reci
	jne uradi #ako nije nula, skacemo na uradi
	incl %ecx #ako jeste nula, samo uvecamo indeks, proveravamo dalje
	jmp proveri_znak
uradi:	movl %ecx, %edi #ovde radim ono premestanje trenutnog indeksa u edi da mogu da izracunam indeks prvog slova
	subl %edx, %edi #od edi oduzmem duzinu reci da mogu dobijem indeks prvog slova
	decl %ecx #indeks poslednjeg slova je indeks trenutnog minus jedan
	movb (%eax, %ecx, 1), %bl #ovo moramo da radimo, to vec znas, da ne mozemo odjednom da poredimo 2 mem. lok. vec
	cmpb %bl, (%eax, %edi, 1) #jednu moramo da premestimo u registar, pa da poredimo sa drugom
	jne pripremi #nisu ista slova? ne povecavamo brojac reci koje imaju isto poslednje i prvo slovo, vec odmah pripremamo proveru 
		     #sledeceg znaka
	incl %esi #ako jesu ista slova, povecamo brojac reci koje imaju isto poslednje i prvo slovo
pripremi:
	movl $0, %edx #vracamo duzinu reci na 0
	addl $2, %ecx #posto smo indeks bili smanjili tamo gore za 1, moramo da ga povecamo za 1(da vratimo na trenutni)+1(da idemo na
		      # sledeci znak
	jmp proveri_znak
izuzetak: #izuzetak nam ovde moze biti: imamo string koji se zavrsava sa slovom ili recju. npr "aka#$@#$kjl"
	cmpl $0, %edx #ako se string ne zavrsava sa recju, nas brojac duzine reci ce biti 0 pa nemamo sta da proveravamo
			#tako da mozemo odmah na kraj
	je kraj
	movl %ecx, %edi #ako nije, kao u primeru sto sam dala, moramo da uporedimo prvo i poslednje slovo te reci kojom
				#se string zavrsava
	subl %edx, %edi #bukvalno sve radi na isti nacin kao gore kad smo proveravali da li su slova ista
	decl %ecx
	movb (%eax, %ecx, 1), %bl
	cmpb %bl, (%eax, %edi, 1)
	jne kraj #ako nisu ista slova, odmah kraj
	incl %esi #ako jesu, povecamo brojac reci koje imaju isto poslednje i prvo slovo i posto smo na kraju stringa
			#nemamo vise sta da proveravamo, propadamo na kraj
kraj:
	movl %esi, %eax #posto smo svo vreme vrednost koja nam je trebala skladistili u esi, samo prebacimo u eax
	popl %esi
	popl %ebx
	popl %edi
	movl %ebp, %esp
	popl %ebp
	ret
	
