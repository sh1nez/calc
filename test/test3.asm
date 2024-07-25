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

%macro NEXT_LINE 0
	mov rax, 1
	mov rdi, 1
	mov rdx, 1
	mov rsi, nline
	syscall
%endmacro

%macro PRINT_NUM 1
	mov rax, 1
	mov rdi, 1
	mov rsi, %1
	syscall
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

	nline db 0x0A

	division_by_zero_message db "division by zero", 0xA
    division_by_zero_length equ $ - division_by_zero_message
    invalid_syntaxsys_message db "invalid syntaxsys", 0xA
    invalid_syntaxsys_length equ $ - invalid_syntaxsys_message



section .text
	global _start

	; lib/error.asm
	extern invalid_syntaxsys
	extern division_by_zero

	;lib/ str.asm
	; extern num2str
	; extern numlen


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

	mov rax, qword [num1]
	call numlen
	mov rsi, num1
	call num2str

	PRINT_NUM num1

	mov rax, 1
	mov rdi, 1
	mov rsi, operator
	mov rdx, 1
	syscall

	mov rax, qword [num2]
	call numlen
	mov rsi, num2
	call num2str

	PRINT_NUM num2

	NEXT_LINE

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

	PRINT

	call is_num_or_sign
	test rax, rax
	jnz short .next1
	ret
.next1:

	PRINT

	call parse_num
	mov qword [num1], rax

	call skip_space

	PRINT

	call is_op
	mov byte [operator], dil
	inc rsi

	PRINT

	call skip_space

	PRINT

	call is_num_or_sign

	jnz short .next2
	ret
.next2:

	call parse_num
	mov qword [num2], rax

	xor rax, rax
	ret

calc: ; rdx dil
    mov dil, byte [operator] 
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




division_by_zero:
	mov rax, 1
	mov rdi, 1
    mov rsi, division_by_zero_message
    mov rdx, division_by_zero_length

	syscall
    ret

invalid_syntaxsys:
	mov rax, 1
	mov rdi, 1
    mov rsi, invalid_syntaxsys_message
    mov rdx, invalid_syntaxsys_length
	syscall

	mov rax, 60
	xor rdi, rdi
    ret

;rax rsi rdx 
num2str: ;-> rsi
	add rsi, rdx
	push rdx
	mov byte [rsi], 0x0A
	mov rbx, 10
.str_loop:
	xor rdx, rdx
	div rbx
	add dl, '0'
	dec rsi
	mov byte [rsi], dl
	test rax, rax
	jnz .str_loop
	pop rdx
	ret

;rax 
numlen:  ; -> rdx
	push rax
	mov rbx, 10
	xor rcx, rcx
.strlen_loop:
	xor rdx, rdx
	div rbx
	inc rcx
	test rax, rax
	jnz .strlen_loop
	pop rax
	mov rdx, rcx
	ret

is_num_or_sign: xor rax, rax
	mov dil, byte [rsi]
    cmp dil, '0'
    jb .not_num_or_sign

    cmp dil, '9'
    ja .not_num_or_sign

    cmp dil, '-'
    je .is_num

    cmp dil, '+'
    je .is_num

.not_num_or_sign:
	mov rax, 1
	ret

.is_num:
	ret


is_op:
	xor rax, rax
    cmp dil, '+' 
    je short .true_op  
    cmp dil, '-' 
    je short .true_op  
    cmp dil, '*' 
    je short .true_op  
    cmp dil, '/' 
    je short .true_op  
    mov rax, 1   
    ret
.true_op:
	ret


skip_space: ;rsi -> not space
.skip:
	mov dil, byte [rsi]
	cmp dil, ' '
	jne .done
	inc rsi
	jmp .skip
.done:
	ret


parse_num:
    xor rax, rax
	mov rbx, 10
.parse_loop:
	movzx rdi, byte [rsi]
	sub rdi, '0'
	jb .done
	cmp rdi, 9
	ja .done
	mul rbx
	add rax, rdi
	inc rsi
	jmp .parse_loop
.done:
	ret
