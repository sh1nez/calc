section .bss
	buffer resb 128
	output resb 32
	num1 resb 8
	num2 resb 8
	operator resb 1

section .data
	text1 db "input string (format: 'num1 op num2')", 0
	len1 equ $ - text1

section .text
	global _start
	extern invalid_syntax


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

	cmp rax, 0
	jnp .main_loop

	mov rax, 60
	xor rdi, rdi
	syscall


%macro IS_OP 0
    cmp rbx, '+' 
    je short .true_op  
    cmp rbx, '-' 
    je short .true_op  
    cmp rbx, '*' 
    je short .true_op  
    cmp rbx, '/' 
    je short .true_op  
    cmp rbx, '%' 
    je short .true_op  
    mov rax, 1   
    ret
.true_op:
%endmacro

%macro IS_NUM_OR_SIGN 0
	cmp rbx, '0'
	jb short .not_num
	cmp rbx, '9'
	ja short .not_num
	jmp short .true_num_sign
.not_num_sign:
	cmp rbx, '-'
	je short .true_num
	cmp rbx, '+'
	je short .true_num_sign
	mov rax, 1
	ret
.true_num_sign:
%endmacro

%macro PRE_SKIP_SPACE 0
.pre_space_loop
	movzx rbx, byte [rsi]
	cmp rbx, ' '
	je short .pre_space_loop
%endmacro

%macro POST_SKIP_SPACE 0
.post_space_loop
	cmp rbx, ' '
	movzx rbx, byte [rsi]
	je short .post_space_loop
%endmacro


; rcx - sum
%marco PARSE_NUM 0
	xor rax, rax
	mov rbx, 10
.num_loop:
	movzx rdi, byte [rsi]
	cmp rdi, '0'
	jb short .
	cmp rdi, '9'
	ja short .num_end
	sub rdi, '0'
	mul rbx
	add rcx, rdi
	inc rsi
	jmp short .num_loop
.num_end:
%endmacro

;rsi - buffer
parse: ; -> [num1], [num2], [op] 
	PRE_SKIP_SPACE

	PARSE_NUM

	POST_SKIP_SPACE

	; PARSE_OP
	mov [operator], [rsi]
	inc rsi

	PRE_SKIP_SPACE

	PARSE_NUM
	
	CALC

	; if \n -> 
	OUTPUT
	; else
	jmp POST_SKIP_SPACE



@macro PARSE_NUM
	mov r8, 1; for negative
	cmp rbx, '0'
	jb short .not_num_sign
	cmp rbx, '9'
	ja short .not_num_sign
	jmp short .true_num_sign ; если число, значит положительное, парсим дальше
.not_num_sign:
	cmp rbx, '-'
	je short .neg_true_num_sign
	cmp rbx, '+'
	je short .true_num_sign
	mov rax, 1
	ret
.neg_true_num_sign:
	neg -1
.true_num_sign:
	mul r8
	mov [num1], rax



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
