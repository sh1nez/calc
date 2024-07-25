%include "lib/print.inc"

section .bss
	buffer resb 32
	output resb 8 
	num1 resb 8
	num2 resb 8
	operator resb 1

section .data
	text1 db "input string (format: 'num1 [+-*/] num2'):   ", 0
	len1 equ $ - text1

	text2 db "result: ", 0
	len2 equ $ - text2

	message db "1", 0x0A
	printlen equ $ - message

	nline db 0x0A


section .text
	global _start

	; lib/error.asm
	extern invalid_syntaxsys
	extern division_by_zero

	; lib/str.asm
	extern num2str
	extern numlen

	; lib/check.asm
	extern is_num_or_sign
	extern is_op

	; lib/parse.asm
	extern skip_space
	extern parse_num


_start:
.main_loop:
	mov rax, 1
	mov rdi, 1
	mov rdx, len1
	mov rsi, text1
	syscall

	mov rax, 0
	mov rdi, 0
	mov rdx, 32
	mov rsi, buffer
	syscall

	call parse
	test rax, rax
	jnz .end

	mov rax, qword [num1]
	mov rbx, qword [num2]
    mov dil, byte [operator] 

	call calc

	jrcxz .continue
	jmp .main_loop
.continue:

	call numlen
	mov rsi, output
	call num2str

	PRINT output, rdx
	
	PRINT nline, 1

	jmp .main_loop

.end:
	call invalid_syntaxsys

	mov rax, 60
	xor rdi, rdi
	syscall

; rsi - buffer
; rdi - tmp
parse: ; -> [num1], [num2], [op] 
	call skip_space

	call is_num_or_sign
	test rax, rax
	jnz short .next1
	ret
.next1:

	call parse_num
	mov qword [num1], rax

	call skip_space


	call is_op
	mov byte [operator], dil
	inc rsi


	call skip_space


	call is_num_or_sign

	jnz short .next2
	ret
.next2:

	call parse_num
	mov qword [num2], rax

	xor rax, rax
	ret

;rax rbx dil
calc:
	xor rcx, rcx
    cmp dil, '*'
    je short .multiply
    cmp dil, '+'
    je short .add
    cmp dil, '-' 
    je short .subtract
    jmp short .divide

.multiply:
    imul rax, rbx
	ret

.add:
    add rax, rbx
	ret

.subtract:
    sub rax, rbx 
	ret

.divide:
    test rbx, rbx
	jz short .error
    xor rdx, rdx
    div rbx
	ret
.error:
	call division_by_zero
	mov rcx, 1
