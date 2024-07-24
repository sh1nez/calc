section .bss
	num1 resb 8
	len1 resb 8

section .text
	text db '123123', 0x0A, 0
	global _start

_start:
	mov rax, -312
	num2str

	mov rax, 60
	xor rdi, rdi
	syscall


num2str:
	cmp rax, 0
	jnl .not_neg:
	mov byte []
.not_neg:
	push rdx
	add rsi, rdx
	mov byte [rsi], '\n'
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

