%macro PRINT 2
	push rax
	push rdi
	push rsi
	push rdx

	mov rax, 1
	mov rdi, 1
	mov rdx, %2; len
	mov rsi, %1; message
	syscall

	pop rdx
	pop rsi
	pop rdi
	pop rax
%endmacro
