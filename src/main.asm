section .bss
    num1 resb 64
	read1 resb 16

section .data
    text1 db "write your first number", 0x0A, 0
    len1 equ $ - text1

section .text
    global _start
	extern int2str ; 
	extern str2int ;

_start:
    mov rax, 1 ; syscall (write)
    mov rdi, 1 ; desdescriptor (stdout)
    mov rsi, text1 ; buffer
    mov rdx, len1 ; len
    syscall   

	mov rax, 0 ; read
	mov rdi, 0 ; stdin
	mov rsi, num1 ; num
	mov rdx, 64; 
	syscall

	mov [read1], rax
	mov rax, 1
	mov rdi, 1
	mov rsi, num1
	mov rdx, [read1]
	syscall

    mov rax, 60            
    xor rdi, rdi          
    syscall


