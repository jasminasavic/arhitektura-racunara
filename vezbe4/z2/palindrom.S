.section .data
	poruka: .ascii "Unesite string:\0"
	por= . - poruka
	nijep:  .ascii "String nije palindrom.\n\0"
	nije= . - nijep
	jestep: .ascii "String je palindrom.\n\0"
	jeste= . - jestep
	
	string_max=51
	string: .fill string_max, 1, 0
	
.section .text
.globl main
main:
	movl $0, %esi
upis:
	movl $4, %eax
	movl $1, %ebx
	leal poruka, %ecx
	movl $por, %edx
	int $0x80
	
	movl $3, %eax
	movl $0, %ebx
	leal string, %ecx
	movl $string_max, %edx
	int $0x80
	
	movl %eax, %edi
	
	cmpl $2, %eax
	je jestef
	
	subl $2, %edi
	
	
poredi: 
	cmpl %esi, %edi
	jb jestef
	
	movb string(, %esi, 1), %bl
	cmpb %bl, string(, %edi, 1)
	jne nijef
	incl %esi
	decl %edi
	jmp poredi
nijef:
	movl $4, %eax
	movl $1, %ebx
	leal nijep, %ecx
	movl $nije, %edx
	int $0x80
	
	jmp kraj
	
jestef:
	movl $4, %eax
	movl $1, %ebx
	leal jestep, %ecx
	movl $jeste, %edx
	int $0x80

kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80













