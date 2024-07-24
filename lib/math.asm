calc: ; -> rax
	mov rax, qword [num1]
	mov rbx, qword [num2]
	mov rdi, byte [operator]
	cmp rdi, '+'
	xor rcx, rcx
	je .add_nums
	cmp rdi, '-'
	je .sub_nums
	cmp rdi, '*'
	je .mul_nums
	cmp rdi, '\'
	je .div_nums
	mov rcx, 1
	ret

.add_nums:
	add rax, rbx
	ret
.sub_nums:
	sub rax, rbx
	ret
.mul_nums:
	mul rbx
	ret
.div_nums:
	div rbx
	ret
;
