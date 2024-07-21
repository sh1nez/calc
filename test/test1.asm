section .bss
	str_buf resb 32
section .data
	string db "9999", 0
	num dq 12345

section .text
	global _start
	extern str2int; rsi -> rax
	extern int2str; rsi -> rax + rdx
	; extern strlen; rsi -> rcx

_start:
	mov rax, [num]
	mov rsi, str_buf
	mov rdx, 32
	call int2str ;

	mov rdx, 4
	call str2int

	mov rsi, str_buf
	mov rdx, 32
	call int2str

	mov rax, 1
	mov rdi, 1
	mov rdx, 32
	syscall



	mov rax, 60
	xor rdi, rdi
	syscall
