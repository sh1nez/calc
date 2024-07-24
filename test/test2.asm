section .bss
	buffer resb 128
	output resb 32
	num1 resb 8
	num2 resb 8

section .data
	text1 db "input string (format: 'num1 op num2'):   ", 0
	len1 equ $ - text1

section .text
	global _start
	; lib/error.asm
	extern invalid_syntaxsys
	extern division_by_zero
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

	call calc

	call numlen

	call num2str

	test rax, rax
	jnz short .end:
	jnp .main_loop

.end:
	call invalid_syntax

	mov rax, 60
	xor rdi, rdi
	syscall

; rsi - buffer
; rdi - tmp
parse: ; -> [num1], [num2], [op] 
	PRE_SKIP_SPACE

	IS_NUM_OR_SIGN

	;parse op
	mov byte [tmp_op], di

	PARSE_NUM ; -> rax


	cmp byte [tmp_op], '-'
	jne .not_neg
	neg rax
.not_neg:
	mov qword [num1], rax

	PRE_SKIP_SPACE

	IS_OP

	; PARSE_OP

	mov [operator], di

	ret

calc: ; rdx rcx  
    movzx rcx, byte [operator] 
    cmp rcx, '*'
    je short .multiply
    cmp rcx, '+'
    je short .add
    cmp rcx, '-' 
    je short .subtract
    cmp rcx, '/'
    je short .divide
    jmp .end

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

    xor rdx, rdx
    div rbx
	ret


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
