global invalid_syntaxsys
global division_by_zero

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

section .data
    division_by_zero_message db "division by zero", 0xA
    division_by_zero_length equ $ - division_by_zero_message
    invalid_syntaxsys_message db "invalid syntaxsys", 0xA
    invalid_syntaxsys_length equ $ - invalid_syntaxsys_message

