%include "lib/check.inc"
%include "lib/parse.inc"

%macro PRINT 0
	push rax
	push rdi
	push rsi
	push rdx

	mov rax, 1
	mov rdi, 1
	mov rdx, printlen
	mov rsi, message
	syscall

	pop rdx
	pop rsi
	pop rdi
	pop rax
%endmacro

section .bss
	buffer resb 128
	output resb 32
	num1 resb 8
	num2 resb 8
	operator resb 1

section .data
	text1 db "input string (format: 'num1 op num2'):   ", 0
	len1 equ $ - text1
	text2 db "result: ", 0
	len2 equ $ - text2
	message db "1", 0x0A
	printlen equ $ - message


section .text
	global _start

	; lib/error.asm
	extern invalid_syntaxsys
	extern division_by_zero

	;lib/ str.asm
	extern num2str
	extern numlen


_start:
.main_loop:
	mov rax, 1
	mov rdi, 1
	mov rdx, len1
	mov rsi, text1
	syscall

	mov rax, 0
	mov rdi, 0
	mov rdx, 128
	mov rsi, buffer
	syscall

	call parse
	test rax, rax
	jnz .end

	mov rax, 1
	mov rdi, 1
	mov rsi, text2
	mov rdx, len2
	syscall

	call calc

	call numlen

	call num2str

	mov rax, 1
	mov rdi, 1
	syscall
	jmp .main_loop

.end:
	call invalid_syntaxsys

	mov rax, 60
	xor rdi, rdi
	syscall

; rsi - buffer
; rdi - tmp
parse: ; -> [num1], [num2], [op] 
	PRE_SKIP_SPACE

	PRINT

	IS_NUM_OR_SIGN

	PRINT

	PARSE_NUM ; -> rax

	mov qword [num1], rax

	PRE_SKIP_SPACE

	PRINT

	IS_OP

	PRINT

	mov byte [operator], dil
	inc rsi

	IS_NUM_OR_SIGN

	PARSE_NUM ; -> rax
	mov qword [num2], rax

	ret

calc: ; rdx dil
    mov dil, byte [operator] 
    cmp dil, '*'
    je short .multiply
    cmp dil, '+'
    je short .add
    cmp dil, '-' 
    je short .subtract
    ; cmp dil, '/'
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

;
; rsi - pointer
; rbx
; пропускать пока пробелы
; если минус сделать не прибавлять, а убавлять числа в операции
; пропускать пока пробелы
; считать знак в буфер
; пропустить пробелы
; читать символы пока не конец строки
; проверить операцию
; прибавить
