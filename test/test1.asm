print_nums:
	mov rax, 1
	mov rdi, 1
	mov rsi, text2
	mov rdx, len2
	syscall

	mov rax, qword [num1]
	call numlen
	mov rsi, num1
	call num2str

	PRINT num1, rdx

	mov rax, 1
	mov rdi, 1
	mov rsi, operator
	mov rdx, 1
	syscall

	mov rax, qword [num2]
	call numlen
	mov rsi, num2
	call num2str

	PRINT num2, rdx


	PRINT nline, 1
