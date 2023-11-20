section .bss
	num1 resb 1
    num2 resb 1
    result resb 1

section .text
    global _start

_start:
    mov rsi, num1  
    mov rdx, 8 
    syscall

    movzx r8, byte [num1]
    sub r8, '0'
	mov [num1], r8

    mov rsi, num2       
    mov rdx, 2          
    mov rax, 0          
    syscall

    movzx r9, byte [num2]
    sub r9, '0'

    add r9, [num1]
    add r9, '0'

    mov [result], r9

    mov rdi, 1           
    mov rsi, result     
    mov rdx, 1          
    mov rax, 1          
    syscall

    mov rax, 60  
    xor rdi, rdi  
    syscall
