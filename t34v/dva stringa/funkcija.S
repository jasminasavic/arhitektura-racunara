#data su dva stringa. treba napraviti potprogram u asembleru koje ce kraci string da kopira
#preko duzeg i vrati koji je string duzi.
#npr. korisnik unese:
#"ovo je!!!!! string 1"
#"string2"
#rezultujuci string ce biti:
#"string2!!!! string 1"
.section .text
.globl funkcija
funkcija:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %ecx
	movl 12(%ebp), %edx
	pushl %esi
	pushl %edi
	pushl %ebx
	movl $0, %esi
	movl $0, %edi
	movl $2, %eax
string1:
	cmpb $0, (%ecx, %esi, 1)
	je string2
	incl %esi
	jmp string1
string2:
	cmpb $0, (%edx, %edi, 1)
	je poredi
	incl %edi
	jmp string2
poredi:
	cmpl %esi, %edi
	ja drugi
	movl $1, %eax
prvi:
	decl %edi
	cmpl $0, %edi
	js kraj
	movb (%edx, %edi, 1), %bl
	movb %bl, (%ecx, %edi, 1)
	jmp prvi
drugi:
	decl %esi
	cmpl $0, %esi
	js kraj
	movb (%ecx, %esi, 1), %bl
	movb %bl, (%edx, %esi, 1)
	jmp drugi
kraj:
	popl %ebx
	popl %edi
	popl %esi
	movl %ebp, %esp
	popl %ebp
	ret
	
	
	
	
	
	
	
	
	
	
	
