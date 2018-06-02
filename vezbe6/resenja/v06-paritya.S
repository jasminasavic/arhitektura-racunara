# Potprogram za postavljanje pariteta niza 16-bitnih brojeva
# Imenko Prezimić ra1234

# Potprogram koristi SetParity za postavljanje pariteta za jedan
# element, pa se i taj potprogram mora dodati prilikom kompajliranja

.section .text

#int SetParity(unsigned short int* v)
SetParity:
    pushl %ebp
    movl %esp, %ebp
    movl 8(%ebp), %ecx
    andw $0x7fff, (%ecx)#postavljanje najvišeg bita na 0 (on se 
                        #ne posmatra prilikom određivanja pariteta)
    movw $1, %dx        #inicijalna maska
    xorl %eax, %eax     #brojač bita
parity_petlja:
    testw %dx, (%ecx)
    jz parity_dalje
    incl %eax
parity_dalje:
    shlw $1, %dx        #sledeća bit pozicija
    jnc parity_petlja
    andl $1, %eax
    pushl %eax
    shlw $1, (%ecx)     #postavljanje najnižeg bita
    shrl $1, %eax       #registra eax (brojač bita)
    rcrw $1, (%ecx)     #u najviši bit 16-bitne promenljive
    popl %eax
parity_kraj:
    movl %ebp, %esp
    popl %ebp
    ret


#int SetParityArray(unsigned short int* niz, int n)
.globl SetParityArray
SetParityArray:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp       #brojač postavljenih jedinica
    movl $0, -4(%ebp)
    pushl %esi          #ovaj registar ostaje sačuvan između poziva (cdecl)
    movl 8(%ebp), %esi  #pa će se koristiti kao pokazivač elemenata niza
paritya_petlja:
    cmpl $0, 12(%ebp)   #da li su obrađeni svi elementi?
    je paritya_kraj
    pushl %esi          #poziv SetParity potprograma
    call SetParity
    addl $4, %esp
    andl %eax, %eax     #da li je postavljena jedinica za paritet?
    jz paritya_dalje
    incl -4(%ebp)
paritya_dalje:
    addl $2, %esi       #sledeći element
    decl 12(%ebp)       #broj elemenata se koristi kao brojač
    jmp paritya_petlja
paritya_kraj:
    popl %esi
    movl -4(%ebp), %eax
    movl %ebp, %esp
    popl %ebp
    ret

