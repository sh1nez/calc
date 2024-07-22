section .bss
	buffer resb 128
	output resb 32
	num resb 8

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

;rsi - buffer
; parse: ; -> [num1], [num2], [op] 
; 	xor rax, rax
; 	; mov byte [rsi+rdx], 0
; .num1_loop:
; 	movzx rbx, byte [rsi]
; 	cmp rbx, 0x30
; 	cmp rbx,
;
; .done:
; 	ret
; .error:
; 	call invalid_syntax
; 	ret
;
; 	; if non 0-9 -> return
