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
	movl $0, %edi
unos:
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
	
	movl %eax, %esi
	
	cmpl $2, %eax
	je jestef
	
	decl %esi
caps:
	cmpl %edi, %esi
	je priprema
	
	cmpb $96, string(, %edi, 1)
	ja vece
	incl %edi
	jmp caps
vece:
	cmpb $123, string(, %edi, 1)
	jb izmeni
	incl %edi
	jmp caps
izmeni:
	movb string(, %edi, 1), %bl
	subb $32, %bl
	movb %bl, string(, %edi, 1)
	incl %edi
	jmp caps
	
priprema:
	movl $0, %edi
	decl %esi
palindrom:
	cmpl %esi, %edi
	ja jestef
	cmpb $32, string(, %edi, 1)
	je povecajd
dalje:	cmpb $32, string(, %esi, 1)
	je smanjis
poredi:
	movb string(, %edi, 1), %bl
	cmpb string(, %esi, 1), %bl
	jne nijef
	incl %edi
	decl %esi
	jmp palindrom


povecajd:
	incl %edi
	jmp dalje
smanjis:
	decl %esi
	jmp poredi
	
jestef:
	movl $4, %eax
	movl $1, %ebx
	leal jestep, %ecx
	movl $jeste, %edx
	int $0x80
	
	jmp kraj
nijef:
	movl $4, %eax
	movl $1, %ebx
	leal nijep, %ecx
	movl $nije, %edx
	int $0x80

kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80













