#potprogram za sabiranje dva broja
.section .text
.globl saberi
#int saberi(int a, int b)
saberi:                   #naziv potprograma
    pushl %ebp            #početak potprograma
    movl %esp, %ebp

    movl 8(%ebp), %eax    #telo potprograma
    addl 12(%ebp), %eax

    movl %ebp, %esp       #završetak potprograma
    popl %ebp
    ret

