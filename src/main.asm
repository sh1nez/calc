section .bss
    num1 resb 64 ; number
	len resb 8 ; len
	read1 resb 32 ; string

section .data
    text1 db "write your first number", 0x0A, 0
    len1 equ $ - text1
	text2 db "write yout second number", 0x0A, 0
	len2 equ $ - text2

section .text
    global _start
	extern int2str ; rax - num; rsi - fd; rdx - len
	extern str2int ; rsi - string

_start:
    mov rax, 1 ; syscall (write)
    mov rdi, 1 ; desdescriptor (stdout)
    mov rsi, text1 ; buffer
    mov rdx, len1 ; len
    syscall   ; write

	mov rax, 0 ; read
	mov rdi, 0 ; stdin
	mov rsi, read1; num
	mov rdx, 64; 
	syscall

	mov rsi, read1
	call str2int

	; mov rax, 321
	inc rax
	mov rsi, num1
	mov rdx, 64
	call int2str

	mov rax, 1
	mov rdi, 1
	mov rdx, 64
	mov rsi, num1
	syscall

    mov rax, 60            
    xor rdi, rdi          
    syscall
