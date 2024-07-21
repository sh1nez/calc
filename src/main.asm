section .bss
	string resb 32
	num1 resb 8
	output resb 32

section .data
	text1 db "Write your first number:... ", 0
    len1 equ $ - text1
	text2 db "Write yout second number:.. ", 0
	len2 equ $ - text2
	text3 db "Sum is ", 0
	len3 equ $ - text3

section .text
    global _start
	extern input_str2int
	extern int2str

_start:
	mov rax, 1
	mov rdi, 1
	mov rdx, len1
	mov rsi, text1
	syscall

	mov rax, 0
	mov rdi, 0
	mov rdx, 32
	mov rsi, string
	syscall

	call input_str2int
	mov [num1], rax
	
	mov rax, 1
	mov rdi, 1
	mov rdx, len2
	mov rsi, text2
	syscall 

	mov rax, 0
	mov rdi, 0
	mov rdx, 32
	mov rsi, string
	syscall

	call input_str2int

	add rax, [num1]
	mov rsi, output
	mov rdx, 32
	call int2str

	mov rax, 1
	mov rdi, 1
	mov rsi, text3
	mov rdx, len3
	syscall

	mov rax, 1
	mov rdi, 1
	mov rdx, 32
	mov rsi, output
	syscall

	mov rax, 60
	xor rdi, rdi
	syscall

