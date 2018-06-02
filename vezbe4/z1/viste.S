.section .data
	poruka1: .ascii "Unesite ime i prezime: \0"
	por1= . - poruka1
	poruka2: .ascii "Vi ste: \0"
	por2= . - poruka2

	string_max=25
	string: .fill string_max,1,0

.section .text
.globl main
main:
	movl $0, %esi
upis:

	movl $4, %eax
	movl $1, %ebx
	leal poruka1, %ecx
	movl $por1, %edx
	int $0x80
	
	movl $3, %eax
	movl $0, %ebx
	leal string, %ecx
	movl $string_max, %edx
	int $0x80
	
	movl %eax, %edi
	decl %edi
	
caps:
	cmpl %esi, %edi
	je ispis
	
	cmpb $96, string(, %esi, 1)
	ja vece
	incl %esi
	jmp caps
	
vece:	cmpb $123, string(, %esi, 1)
	jb izmeni
	incl %esi
	jmp caps
	
izmeni:
	movb string(, %esi, 1), %bl
	subb $32, %bl
	movb %bl, string(, %esi, 1)
	incl %esi
	jmp caps



ispis:
	incl %edi
	
	movl $4, %eax
	movl $1, %ebx
	leal poruka2, %ecx
	movl $por2, %edx
	int $0x80

	movl $4, %eax
	movl $1, %ebx
	leal string, %ecx
	movl %edi, %edx
	int $0x80

kraj: 
	movl $1, %eax
	movl $0, %ebx
	int $0x80
